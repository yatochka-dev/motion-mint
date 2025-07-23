-- name: InsertRep :one
INSERT INTO rep (
    workout_set_id, rep_index, quality_score
) VALUES (
             $1, $2, $3
         ) RETURNING *;

-- name: ListRepsForSet :many
SELECT *
FROM rep
WHERE workout_set_id = $1
ORDER BY rep_index;

-- name: GetMaxRepIndex :one
SELECT COALESCE(MAX(rep_index), 0) AS max_idx
FROM rep
WHERE workout_set_id = $1;
