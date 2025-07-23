-- name: CreateWorkoutSet :one
INSERT INTO workout_set (
    workout_id, exercise_id, cxx_pod, expires_at, started_at
) VALUES (
             $1, $2, $3, $4, $5
         ) RETURNING *;

-- name: UpdateWorkoutSetStatus :exec
UPDATE workout_set
SET   status     = $2,
      ended_at   = CASE WHEN $2 IN (1,2) THEN now() ELSE ended_at END
WHERE id = $1;

-- name: GetActiveSetByWorkout :one
SELECT *
FROM workout_set
WHERE workout_id = $1
  AND status = 'ACTIVE'                   -- active
    LIMIT 1;

-- name: ListSetsByWorkout :many
SELECT *
FROM workout_set
WHERE workout_id = $1
ORDER BY started_at;
