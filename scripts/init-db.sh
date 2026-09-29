CREATE USER 'readonly'@'%' IDENTIFIED BY 'StrongPassword';
GRANT SELECT ON wordpress.* TO 'readonly'@'%';
FLUSH PRIVILEGES;