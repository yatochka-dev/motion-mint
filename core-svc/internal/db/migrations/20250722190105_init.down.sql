-- v1_down.sql  — roll back initial schema
BEGIN;
DROP TYPE  workout_set_status;

-- Children-of-session
DROP TABLE IF EXISTS rep;
DROP TABLE IF EXISTS refresh_token;

-- Parents
DROP TABLE IF EXISTS workout_set;
DROP TABLE IF EXISTS workout;
DROP TABLE IF EXISTS exercise;
DROP TABLE IF EXISTS app_user;

COMMIT;
