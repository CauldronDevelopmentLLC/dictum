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
  kotus        INT UNSIGNED,
  freq         INT NOT NULL DEFAULT 0,
  KEY (kotus),
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


CREATE TABLE IF NOT EXISTS user_tags (
  uid          INT,
  tid          INT,
  PRIMARY KEY (uid, tid),
  FOREIGN KEY (tid) REFERENCES tags(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS word_data (
  uid          INT,
  wid          INT,
  notes        TEXT,
  score        INT DEFAULT 0,
  PRIMARY KEY (uid, wid),
  FOREIGN KEY (uid) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (wid) REFERENCES words(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE IF NOT EXISTS history (
  uid          INT,
  wid          INT,
  ts           TIMESTAMP,
  PRIMARY KEY (uid, wid, ts),
  FOREIGN KEY (uid) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (wid) REFERENCES words(id) ON DELETE CASCADE
) CHARSET=utf8mb4 COLLATE utf8mb4_bin;


-- Functions
DELIMITER //
DROP FUNCTION IF EXISTS FindTagID;
CREATE FUNCTION FindTagID(_name VARCHAR(16))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @id = NULL;
  SELECT id INTO @id FROM tags WHERE name = _name;
  RETURN @id;
END //
DELIMITER ;


DELIMITER //
DROP FUNCTION IF EXISTS GetTagID;
CREATE FUNCTION GetTagID(_name VARCHAR(16))
  RETURNS INT
  READS SQL DATA
BEGIN
  SET @id = FindTagId(_name);

  IF ISNULL(@id) THEN
    INSERT INTO tags (name) VALUES (_name);
    SET @id = LAST_INSERT_ID();
  END IF;

  RETURN @id;
END //
DELIMITER ;


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


-- Words
DELIMITER //
DROP PROCEDURE IF EXISTS GetWord;
CREATE PROCEDURE GetWord(
  IN _sid VARCHAR(48),
  IN _word VARCHAR(128))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthSIDToUID(_sid);
  SET @wid = GetWordID(_word);

  -- Data
  SET @notes = NULL;
  SET @score = NULL;
  SELECT notes, score INTO @notes, @score FROM word_data
    WHERE uid = @uid AND wid = @wid;

  -- Data
  SELECT @notes notes, @score score, COUNT(*) visits, MAX(ts) last FROM history
    WHERE uid = @uid AND wid = @wid;

  -- Tags
  SELECT t.name FROM word_tags wt
    JOIN tags t ON t.id = wt.tid
    WHERE (wt.uid = @uid OR wt.uid = 0) AND wt.wid = @wid
    GROUP BY wt.tid;

  -- History
  START TRANSACTION;
  SET @dayago = DATE_SUB(NOW(), INTERVAL 1 DAY);
  DELETE FROM history WHERE uid = @uid AND wid = @wid AND @dayago < ts;
  INSERT INTO history (uid, wid, ts) VALUES (@uid, @wid, NOW());
  COMMIT;
END //
DELIMITER ;


-- Tags
DELIMITER //
DROP PROCEDURE IF EXISTS GetTag;
CREATE PROCEDURE GetTag(IN _sid VARCHAR(48), IN _uid INT, IN _tag VARCHAR(256))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthLookupSID(_sid);
  SET @tid = FindTagID(_tag);
  SET @tagUID = IFNULL(_uid, @uid);

  SELECT w.word, w.freq, wd1.notes, wd2.score FROM word_tags wt
    JOIN words w ON w.id = wt.wid
    LEFT JOIN word_data wd1 ON wd1.wid = wt.wid AND wd1.uid = @tagUID
    LEFT JOIN word_data wd2 ON wd2.wid = wt.wid AND wd2.uid = @uid
    WHERE (wt.uid = @tagUID OR wt.uid = 0) AND wt.tid = @tid
    ORDER BY w.freq DESC LIMIT 10000;
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
  SET @uid = AuthSIDToUID(_sid);
  SET @wid = GetWordID(_word);
  SET @tid = FindTagID(_tag);

  DELETE FROM word_tags WHERE uid = @uid AND tid = @tid AND wid = @wid;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetUserTags;
CREATE PROCEDURE GetUserTags(IN _sid VARCHAR(48))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthSIDToUID(_sid);

  SELECT t.name tag FROM user_tags u
    LEFT JOIN tags t ON u.tid = t.id
    WHERE uid = @uid;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS AddUserTag;
CREATE PROCEDURE AddUserTag(IN _sid VARCHAR(48), IN _tag VARCHAR(32))
SQL SECURITY DEFINER
BEGIN
  INSERT INTO user_tags (uid, tid)
    VALUES (AuthSIDToUID(_sid), GetTagID(_tag))
    ON DUPLICATE KEY UPDATE uid = uid;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS DeleteUserTag;
CREATE PROCEDURE DeleteUserTag(IN _sid VARCHAR(48), IN _tag VARCHAR(32))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthSIDToUID(_sid);
  SET @tid = FindTagID(_tag);
  DELETE FROM user_tags WHERE uid = @uid AND tid = @tid;
END //
DELIMITER ;


-- Word Data
DELIMITER //
DROP PROCEDURE IF EXISTS SetWordNotes;
CREATE PROCEDURE SetWordNotes(
  IN _sid VARCHAR(48),
  IN _word VARCHAR(255),
  IN _notes TEXT)
SQL SECURITY DEFINER
BEGIN
  INSERT INTO word_data (uid, wid, notes)
    VALUES (AuthSIDToUID(_sid), GetWordID(_word), _notes)
    ON DUPLICATE KEY UPDATE notes = VALUES(notes);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS SetWordScore;
CREATE PROCEDURE SetWordScore(
  IN _sid VARCHAR(48),
  IN _word VARCHAR(255),
  IN _score INT)
SQL SECURITY DEFINER
BEGIN
  INSERT INTO word_data (uid, wid, score)
    VALUES (AuthSIDToUID(_sid), GetWordID(_word), _score)
    ON DUPLICATE KEY UPDATE score = VALUES(score);
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetTags;
CREATE PROCEDURE GetTags(IN _sid VARCHAR(48))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthLookupSID(_sid);

  SELECT COUNT(wt.tid) count, t.name, wt.uid FROM word_tags wt
    JOIN tags t on t.id = wt.tid
    WHERE wt.uid = 0 OR wt.uid = @uid
    GROUP BY wt.tid ORDER BY count DESC;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS GetUserHistory;
CREATE PROCEDURE GetUserHistory(IN _sid VARCHAR(48))
SQL SECURITY DEFINER
BEGIN
  SET @uid = AuthSIDToUID(_sid);

  SELECT w.word, d.notes, d.score, DATE_FORMAT(h.ts, '%Y-%m-%dT%TZ') as `time`
    FROM history h
    LEFT JOIN words w ON w.id = h.wid
    LEFT JOIN word_data d ON d.uid = @uid AND d.wid = h.wid
    WHERE h.uid = @uid
    ORDER BY h.ts DESC LIMIT 10000;
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
