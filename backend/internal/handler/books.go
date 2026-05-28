package handler

import (
	"bookshelf/converter"
	"bookshelf/internal/database"
	"bookshelf/internal/response"
	"encoding/json"
	"log"
	"net/http"
	"time"

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

	books, err := cfg.DB.GetBooksByUserID(r.Context(), userId)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user's books")
		return
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

	type BookJSONRequest struct {
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

	books := []BookJSONRequest{}
	decoder := json.NewDecoder(r.Body)
	err = decoder.Decode(&books)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	for _, book := range books {
		if book.ID == uuid.Nil || book.UpdatedAt.IsZero() {
			response.RespondWithError(w, http.StatusBadRequest, "Books must have uuid and updated_at")
			return
		}
		_, err = cfg.DB.InsertBook(r.Context(), database.InsertBookParams{
			ID:          book.ID,
			UserID:      userId,
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
		})
	}
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}

func (cfg *ApiConfig) EditBooks(w http.ResponseWriter, r *http.Request) {
	type BookJSONRequest struct {
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

	books := []BookJSONRequest{}
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&books)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	for _, book := range books {
		if book.ID == uuid.Nil || book.UpdatedAt.IsZero() {
			response.RespondWithError(w, http.StatusBadRequest, "Books must have uuid and updated_at")
			return
		}
		_, err = cfg.DB.EditBook(r.Context(), database.EditBookParams{
			ID:          book.ID,
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
		})
	}
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}
