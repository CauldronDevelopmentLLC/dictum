# Dictum
Personal dictionary

# Create DB & load schema

    echo 'CREATE DATABASE dictum;' | mysql -u root -p
    mysql -u root -p dictum < dictum.sql

# Create DB User

    CREATE USER 'dictum'@'localhost' IDENTIFIED BY 'password';
    GRANT EXECUTE on dictum.* TO 'dictum'@'localhost';
    FLUSH PRIVILEGES;

# Run API server

    jmpapi api/jmpapi.yaml local.yaml


# Run Development Web Server

    npm run dev
