-- name: CreateRefreshToken :exec
INSERT INTO refresh_token (
    token, user_id, expires_at, user_agent
) VALUES ($1, $2, $3, $4);

-- name: DeleteRefreshToken :exec
DELETE FROM refresh_token
WHERE token = $1;

-- name: GetRefreshToken :one
SELECT *
FROM refresh_token
WHERE token = $1
  AND expires_at > now();          -- ignore expired
