package handler

import (
	"bookshelf/internal/crypto"
	"bookshelf/internal/database"
	"bookshelf/internal/response"
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/google/uuid"
)

func (cfg *ApiConfig) Register(w http.ResponseWriter, r *http.Request) {
	type parameters struct {
		Username string
		Password string
	}

	decoder := json.NewDecoder(r.Body)
	params := parameters{}
	err := decoder.Decode(&params)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't decode parameter")
		return
	}

	hashPassword, err := crypto.HashPassword(params.Password)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn' hash user password")
		return
	}

	user, err := cfg.DB.CreateUser(r.Context(), database.CreateUserParams{
		ID:        uuid.New(),
		CreatedAt: time.Now().UTC(),
		Username:  params.Username,
		Password:  hashPassword,
	})

	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't create user")
		return
	}

	response.RespondWithJSON(w, http.StatusCreated, struct {
		Id        uuid.UUID `json:"id"`
		Username  string    `json:"username"`
		CreatedAt time.Time `json:"created_at"`
	}{
		Id:        user.ID,
		Username:  user.Username,
		CreatedAt: user.CreatedAt,
	})
}
