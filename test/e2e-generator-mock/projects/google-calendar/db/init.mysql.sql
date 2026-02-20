-- test/e2e-generator-mock/projects/google-calendar/db/init.mysql.sql
-- MySQL init: database google_calendar_mock para E2E (projeto google-calendar)
CREATE DATABASE IF NOT EXISTS google_calendar_mock;
GRANT ALL PRIVILEGES ON google_calendar_mock.* TO 'e2e'@'%';

USE google_calendar_mock;
