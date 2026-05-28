package models

import (
	"bookshelf/converter"
	"bookshelf/internal/database"
	"time"

	"github.com/google/uuid"
)

type Book struct {
	ID          uuid.UUID `json:"id"`
	UpdatedAt   time.Time `json:"updated_at"`
	Title       string    `json:"title"`
	Author      *string   `json:"author"`
	Genre       *string   `json:"genre"`
	PageMax     *int32    `json:"page_max"`
	PageCurrent *int32    `json:"page_current"`
	Description *string   `json:"description"`
	Note        *string   `json:"note"`
	Rating      *int32    `json:"rating"`
	Progress    *string   `json:"progress"`
	Isbn        *string   `json:"ISBN"`
}

// Database of book have different data type from json book format.
// we need these function to convert to each other
func (book *Book) ToDatabaseFormat(userID uuid.UUID) database.Book {
	return database.Book{
		ID:          book.ID,
		UserID:      userID,
		UpdatedAt:   book.UpdatedAt,
		Title:       book.Title,
		Author:      converter.NewNullString(book.Author),
		Genre:       converter.NewNullString(book.Genre),
		PageMax:     converter.NewNullInt32(book.PageMax),
		PageCurrent: converter.NewNullInt32(book.PageCurrent),
		Description: converter.NewNullString(book.Description),
		Note:        converter.NewNullString(book.Note),
		Rating:      converter.NewNullInt32(book.Rating),
		Progress:    converter.NewNullString(book.Progress),
		Isbn:        converter.NewNullString(book.Isbn),
	}
}

func BookDatabaseToBasicJSONFormat(bookDB database.Book) Book {
	return Book{
		ID:          bookDB.ID,
		UpdatedAt:   bookDB.UpdatedAt,
		Title:       bookDB.Title,
		Author:      &bookDB.Author.String,
		Genre:       &bookDB.Genre.String,
		PageMax:     &bookDB.PageMax.Int32,
		PageCurrent: &bookDB.PageCurrent.Int32,
		Description: &bookDB.Description.String,
		Note:        &bookDB.Note.String,
		Rating:      &bookDB.Rating.Int32,
		Progress:    &bookDB.Progress.String,
		Isbn:        &bookDB.Isbn.String,
	}
}
