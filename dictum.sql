CREATE DATABASE IF NOT EXISTS dictum CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  provider     VARCHAR(16) NOT NULL,
  provider_id  VARCHAR(128),
  email        VARCHAR(128) NOT NULL UNIQUE,
  name         VARCHAR(128),
  avatar       VARCHAR(256),
  created      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_used    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY (provider, provider_id)
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS sessions (
  id           VARCHAR(48) NOT NULL PRIMARY KEY,
  uid          INT,
  created      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_used    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (uid) REFERENCES users(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS words (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  word         VARCHAR(128) NOT NULL UNIQUE,
  freq         INT NOT NULL DEFAULT 0,
  KEY (freq)
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS tags (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(16) NOT NULL UNIQUE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS word_tags (
  uid          INT,
  tid          INT,
  wid          INT,
  PRIMARY KEY (uid, tid, wid),
  FOREIGN KEY (tid) REFERENCES tags(id)  ON DELETE CASCADE,
  FOREIGN KEY (wid) REFERENCES words(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS word_notes (
  uid          INT,
  wid          INT,
  text         TEXT,
  PRIMARY KEY (uid, wid),
  FOREIGN KEY (uid) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (wid) REFERENCES words(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;



-- Words
DELIMITER //
DROP FUNCTION IF EXISTS GetWordID;
CREATE FUNCTION GetWordID(_word VARCHAR(128))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @id = NULL;
  SELECT id INTO @id FROM words WHERE word = _word;

  IF ISNULL(@id) THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Word not found.';
  END IF;

  RETURN @id;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetWords;
CREATE PROCEDURE GetWords(IN _sid VARCHAR(48), IN _tags VARCHAR(256))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthLookupSID(_sid);
  SET @num = LENGTH(_tags) - LENGTH(REPLACE(_tags, ',', '')) + 1;

  IF ISNULL(_tags) THEN
    SELECT w.word, wn.text notes FROM words w
      LEFT JOIN word_notes wn ON wn.wid = w.id AND wn.uid = @uid
      ORDER BY freq DESC LIMIT 10000;

  ELSE
    SELECT w.word, wn.text notes FROM word_tags wt
      JOIN words w ON w.id = wt.wid
      LEFT JOIN word_notes wn ON wn.wid = wt.wid AND wn.uid = @uid
      WHERE (wt.uid = @uid OR wt.uid = 0) AND
        tid IN (SELECT id FROM tags WHERE FIND_IN_SET(name, _tags))
      GROUP BY wt.wid HAVING COUNT(tid) = @num ORDER BY freq DESC LIMIT 10000;
  END IF;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetWord;
CREATE PROCEDURE GetWord(
  IN _sid VARCHAR(48),
  IN _word VARCHAR(128))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthSIDToUID(_sid);
  SET @wid = GetWordID(_word);

  -- Notes
  SELECT text notes FROM word_notes WHERE uid = @uid AND wid = @wid;

  -- Tags
  SELECT t.name FROM word_tags wt
    JOIN tags t ON t.id = wt.tid
    WHERE (wt.uid = @uid OR wt.uid = 0) AND wt.wid = @wid
    GROUP BY wt.tid;
END //
DELIMITER ;


-- Tags
DELIMITER //
DROP FUNCTION IF EXISTS GetTagID;
CREATE FUNCTION GetTagID(_name VARCHAR(16))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @id = NULL;

  SELECT id INTO @id FROM tags WHERE name = _name;

  IF ISNULL(@id) THEN
    INSERT INTO tags (name) VALUES (_name);
    SET @id = LAST_INSERT_ID();
  END IF;

  RETURN @id;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS TagWord;
CREATE PROCEDURE TagWord(
  IN _sid  VARCHAR(48),
  IN _word VARCHAR(128),
  IN _tag  VARCHAR(32))
SQL SECURITY DEFINER
BEGIN
  INSERT INTO word_tags (uid, wid, tid)
    VALUES (AuthSIDToUID(_sid), GetWordID(_word), GetTagID(_tag))
    ON DUPLICATE KEY UPDATE wid = VALUES(wid);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS UntagWord;
CREATE PROCEDURE UntagWord(
  IN _sid  VARCHAR(48),
  IN _word VARCHAR(128),
  IN _tag  VARCHAR(32))
SQL SECURITY DEFINER
BEGIN
  DELETE FROM word_tags WHERE uid = AuthSIDToUID(_sid) AND
    tid = GetTagID(_tag) AND wid = GetWordID(_word);
END //
DELIMITER ;


-- Word Notes
DELIMITER //
DROP PROCEDURE IF EXISTS SetWordNotes;
CREATE PROCEDURE SetWordNotes(
  IN _sid VARCHAR(48),
  IN _word VARCHAR(255),
  IN _notes TEXT)
SQL SECURITY DEFINER
BEGIN
  INSERT INTO word_notes (uid, wid, text)
    VALUES (AuthSIDToUID(_sid), GetWordID(_word), _notes)
    ON DUPLICATE KEY UPDATE text = VALUES(text);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS DeleteWordNotes;
CREATE PROCEDURE DeleteWordNotes(IN _sid VARCHAR(48), IN _word VARCHAR(255))
SQL SECURITY DEFINER
BEGIN
  DELETE FROM word_notes
    WHERE uid = AuthSIDToUID(_sid) AND wid = GetWordID(_word);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetTags;
CREATE PROCEDURE GetTags(IN _sid VARCHAR(48), IN _tags VARCHAR(256))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthLookupSID(_sid);

  SELECT COUNT(wt.tid) count, t.name FROM word_tags wt
    JOIN tags t on t.id = wt.tid
    WHERE (wt.uid = 0 OR wt.uid = @uid) AND ISNULL(_tags) OR
      wt.wid in (SELECT wid FROM word_tags wt JOIN tags t ON t.id = wt.tid
        WHERE FIND_IN_SET(t.name, _tags))
    GROUP BY wt.tid ORDER BY count DESC;
END //
DELIMITER ;


-- Auth
DELIMITER //
DROP PROCEDURE IF EXISTS AuthLogin;
CREATE PROCEDURE AuthLogin(
  IN _sid         VARCHAR(48),
  IN _provider    VARCHAR(16),
  IN _provider_id VARCHAR(128),
  IN _email       VARCHAR(128),
  IN _name        VARCHAR(128),
  IN _avatar      VARCHAR(256))
  SQL SECURITY DEFINER
BEGIN
  SET @@session.time_zone = '+00:00';

  IF ISNULL(_name) OR LENGTH(_name) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User name cannot be empty';
  END IF;

  -- Create or update user
  INSERT INTO users (provider, provider_id, email, name, avatar)
    VALUES (_provider, _provider_id, _email, _name, _avatar)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), last_used = NOW();
  SET @uid = LAST_INSERT_ID();

  -- Create or update session
  INSERT INTO sessions (id, uid) VALUES (_sid, @uid)
    ON DUPLICATE KEY UPDATE last_used = NOW();

  -- Delete all old sessions
  DELETE FROM sessions WHERE last_used < (NOW() - INTERVAL 4 DAY);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS AuthLogout;
CREATE PROCEDURE AuthLogout(IN _sid VARCHAR(48))
  SQL SECURITY DEFINER
BEGIN
  SET @@session.time_zone = '+00:00';
  DELETE FROM sessions WHERE id = _sid;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS AuthSession;
CREATE PROCEDURE AuthSession(IN _sid VARCHAR(48))
  SQL SECURITY DEFINER
BEGIN
  SET @@session.time_zone = '+00:00';

  -- Delete old sessions
  SET @timeout = 2592000;
  DELETE FROM sessions WHERE last_used + INTERVAL @timeout SECOND < NOW();

  -- Get session, if it exists
  SELECT u.id uid, u.email user, u.name, u.avatar,
    DATE_FORMAT(s.created, '%Y-%m-%dT%TZ') created,
    DATE_FORMAT(s.last_used, '%Y-%m-%dT%TZ') last_used
    FROM sessions s
    JOIN users u ON s.id = _sid AND s.uid = u.id;

  -- Update session last_used
  UPDATE sessions SET last_used = NOW() WHERE id = _sid;
END //
DELIMITER ;


DELIMITER //
DROP FUNCTION IF EXISTS AuthLookupSID;
CREATE FUNCTION AuthLookupSID(_sid VARCHAR(48))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @uid = NULL;
  SELECT uid INTO @uid FROM sessions WHERE id = _sid;
  RETURN @uid;
END //
DELIMITER ;


DELIMITER //
DROP FUNCTION IF EXISTS AuthSIDToUID;
CREATE FUNCTION AuthSIDToUID(_sid VARCHAR(48))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @uid = AuthLookupSID(_sid);

  IF ISNULL(@uid) THEN
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Session not found.';
  END IF;

  RETURN @uid;
END //
DELIMITER ;
