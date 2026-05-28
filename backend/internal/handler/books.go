package handler

import (
	"bookshelf/internal/database"
	"bookshelf/internal/models"
	"bookshelf/internal/response"
	"encoding/json"
	"log"
	"net/http"

	"github.com/google/uuid"
)

func (cfg *ApiConfig) GetBooks(w http.ResponseWriter, r *http.Request) {
	username := r.Context().Value("username").(string)
	userId, err := cfg.DB.GetUserIDByUsername(r.Context(), username)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user id")
		return
	}

	booksDB, err := cfg.DB.GetBooksByUserID(r.Context(), userId)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user's books")
		return
	}

	books := make([]models.Book, len(booksDB))
	for i, book := range booksDB {
		books[i] = models.BookDatabaseToBasicJSONFormat(book)
	}

	response.RespondWithJSON(w, http.StatusOK, books)
}

func (cfg *ApiConfig) AddBooks(w http.ResponseWriter, r *http.Request) {
	username := r.Context().Value("username").(string)
	userId, err := cfg.DB.GetUserIDByUsername(r.Context(), username)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user id")
		return
	}

	books := []models.Book{}
	decoder := json.NewDecoder(r.Body)
	err = decoder.Decode(&books)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	for _, book := range books {
		bookDB := book.ToDatabaseFormat(userId)
		if bookDB.ID == uuid.Nil || bookDB.UpdatedAt.IsZero() {
			response.RespondWithError(w, http.StatusBadRequest, "Books must have uuid and updated_at")
			return
		}
		_, err = cfg.DB.InsertBook(r.Context(), database.InsertBookParams{
			ID:          bookDB.ID,
			UserID:      userId,
			UpdatedAt:   bookDB.UpdatedAt,
			Title:       bookDB.Title,
			Author:      bookDB.Author,
			Genre:       bookDB.Genre,
			PageMax:     bookDB.PageMax,
			PageCurrent: bookDB.PageCurrent,
			Description: bookDB.Description,
			Note:        bookDB.Note,
			Rating:      bookDB.Rating,
			Progress:    bookDB.Progress,
			Isbn:        bookDB.Isbn,
		})
	}
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}

func (cfg *ApiConfig) EditBooks(w http.ResponseWriter, r *http.Request) {

	books := []models.Book{}
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&books)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	for _, book := range books {
		bookDB := book.ToDatabaseFormat(uuid.Nil) // we don't need userID
		if bookDB.ID == uuid.Nil || bookDB.UpdatedAt.IsZero() {
			response.RespondWithError(w, http.StatusBadRequest, "Books must have uuid and updated_at")
			return
		}
		_, err = cfg.DB.EditBook(r.Context(), database.EditBookParams{
			ID:          bookDB.ID,
			UpdatedAt:   bookDB.UpdatedAt,
			Title:       bookDB.Title,
			Author:      bookDB.Author,
			Genre:       bookDB.Genre,
			PageMax:     bookDB.PageMax,
			PageCurrent: bookDB.PageCurrent,
			Description: bookDB.Description,
			Note:        bookDB.Note,
			Rating:      bookDB.Rating,
			Progress:    bookDB.Progress,
			Isbn:        bookDB.Isbn,
		})
	}
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}
