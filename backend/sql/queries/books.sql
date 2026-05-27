-- name: InsertBook :one
INSERT INTO books (id, user_id, updated_at, title, author, genre, page_max, page_current, description, note, rating, progress, ISBN)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING *;

-- name: GetBooks :many
SELECT * FROM books;

-- name: DeleteBook :exec
DELETE FROM books WHERE id = $1;

-- name: EditBook :one
UPDATE books
SET updated_at = $2, 
    title = $3, 
    author = $4, 
    genre = $5, 
    page_max = $6, 
    page_current = $7, 
    description = $8, 
    note = $9, 
    rating = $10, 
    progress = $11, 
    ISBN = $12
WHERE id = $1
RETURNING *;