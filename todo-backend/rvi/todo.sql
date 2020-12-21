
DROP TABLE IF EXISTS `Item`;
CREATE TABLE IF NOT EXISTS `Item` (id BIGINT NOT NULL auto_increment UNIQUE , description VARCHAR(255), done TINYINT(1), PRIMARY KEY (id)) ENGINE=InnoDB;

INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Populate external database', true);
INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Create project in OpenShift', true);
INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Deploy To Do List application in OpenShift', true);
INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Create service that will point to external database', false);
INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Add endpoint to service that points to the external database server', false);
INSERT INTO `Item` (id, description, done) VALUES (DEFAULT, 'Verify that the To Do List application works', false);


