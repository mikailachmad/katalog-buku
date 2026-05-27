-- +goose Up
CREATE TABLE books (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    title TEXT NOT NULL,
    author varchar(255),
    genre varchar(100),
    page_max INT DEFAULT 0,
    page_current INT DEFAULT 0,
    description TEXT DEFAULT '',
    note TEXT DEFAULT '',
    rating INT DEFAULT 0,
    progress varchar(50) DEFAULT 'belum',
    ISBN varchar(20) 
);

-- +goose Down
DROP TABLE books;