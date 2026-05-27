-- name: CreateUser :one
INSERT INTO users (id, created_at, username, password)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetUserById :one
SELECT * FROM users WHERE id = $1;

-- name: GetUserByUsername :one
SELECT * FROM users WHERE username = $1;