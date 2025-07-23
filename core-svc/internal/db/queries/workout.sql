-- name: CreateWorkoutForUser :one
INSERT INTO workout (user_id)
VALUES ($1)
    RETURNING *;

-- name: FinishWorkout :exec
UPDATE workout
SET ended_at = now()
WHERE id = $1
  AND ended_at IS NULL;            -- idempotent (even if I call like 20 times, changes only once)

-- name: GetWorkout :one
SELECT * FROM workout
WHERE id = $1;

-- name: ListWorkoutsByUser :many
SELECT *
FROM workout
WHERE user_id = $1
ORDER BY started_at DESC
    LIMIT $2 OFFSET $3;                -- simple pagination
