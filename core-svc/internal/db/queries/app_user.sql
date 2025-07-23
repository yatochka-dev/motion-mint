-- name: CreateUser :one
INSERT INTO app_user (email)
VALUES ($1) RETURNING *;                       -- id, email, created_at

-- name: GetUserByID :one
SELECT * FROM app_user
WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * FROM app_user
WHERE email = $1 LIMIT 1;
