package handler

import "bookshelf/internal/database"

type ApiConfig struct {
	DB *database.Queries
}
