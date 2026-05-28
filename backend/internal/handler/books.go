package handler

import (
	"bookshelf/internal/database"
	"bookshelf/internal/models"
	"bookshelf/internal/response"
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
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

	addedBook := 0
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
		if err == nil {
			addedBook++
		}
	}
	// kalau ga ada buku yg ditambah sama sekali, beri pesan error
	if err != nil && addedBook == 0 {
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

	editedBook := 0
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
		if err == nil {
			editedBook++
		}
	}
	// kalau ga ada buku yg teredit sama sekali, beri pesan error
	if err != nil && editedBook == 0 {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}

func (cfg *ApiConfig) DeleteBooks(w http.ResponseWriter, r *http.Request) {
	username := r.Context().Value("username").(string)
	userId, err := cfg.DB.GetUserIDByUsername(r.Context(), username)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user id")
		return
	}

	params := []uuid.UUID{}
	decoder := json.NewDecoder(r.Body)
	err = decoder.Decode(&params)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	deletedBook := 0
	for _, bookID := range params {
		err = cfg.DB.DeleteBook(r.Context(), database.DeleteBookParams{
			UserID: userId,
			ID:     bookID,
		})
		if err != sql.ErrNoRows && err == nil {
			deletedBook++
		}
	}
	// beri pesan error jika tidak ada buku yg terhapus sama sekali
	if err == sql.ErrNoRows && deletedBook == 0 {
		response.RespondWithError(w, http.StatusBadRequest, "Invalid book's id")
		return
	}
	if err != nil && deletedBook == 0 {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}

func (cfg *ApiConfig) DeleteBook(w http.ResponseWriter, r *http.Request) {
	username := r.Context().Value("username").(string)
	userId, err := cfg.DB.GetUserIDByUsername(r.Context(), username)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user id")
		return
	}

	idParam := chi.RouteContext(r.Context()).URLParam("bookId")
	log.Println(idParam)
	bookId, err := uuid.Parse(idParam)
	if err != nil || idParam == "" {
		response.RespondWithError(w, http.StatusBadRequest, "Couldn't parse book id parameter")
		return
	}

	err = cfg.DB.DeleteBook(r.Context(), database.DeleteBookParams{
		UserID: userId,
		ID:     bookId,
	})

	if err == sql.ErrNoRows {
		response.RespondWithError(w, http.StatusBadRequest, "Invalid book's id")
		return
	}
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}
