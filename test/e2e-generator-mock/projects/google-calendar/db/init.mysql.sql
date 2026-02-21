-- test/e2e-generator-mock/projects/google-calendar/db/init.mysql.sql
-- MySQL init: database google_calendar para E2E (projeto google-calendar)
CREATE DATABASE IF NOT EXISTS google_calendar;
GRANT ALL PRIVILEGES ON google_calendar.* TO 'e2e'@'%';

USE google_calendar;
