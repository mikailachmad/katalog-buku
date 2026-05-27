package handler

import (
	"bookshelf/internal/auth"
	"bookshelf/internal/crypto"
	"bookshelf/internal/database"
	"bookshelf/internal/response"
	"database/sql"
	"encoding/json"
	"errors"
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

func (cfg *ApiConfig) Login(w http.ResponseWriter, r *http.Request) {
	type parameters struct {
		Username string
		Password string
	}

	decoder := json.NewDecoder(r.Body)
	params := parameters{}
	err := decoder.Decode(&params)
	if err != nil {
		response.RespondWithError(w, http.StatusInternalServerError, "Couldn't Decode Parameters")
		return
	}

	user, err := cfg.DB.GetUserByUsername(r.Context(), params.Username)
	if errors.Is(err, sql.ErrNoRows) {
		log.Println(err)
		response.RespondWithError(w, http.StatusUnauthorized, "Username wrong")
		return
	}
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't get user")
		return
	}

	if !crypto.PasswordMatch(params.Password, user.Password) {
		log.Println(err)
		response.RespondWithError(w, http.StatusUnauthorized, "Password wrong")
		return
	}

	signedToken, err := auth.GenerateJWT(user.Username)
	if err != nil {
		log.Println(err)
		response.RespondWithError(w, http.StatusInternalServerError, "Can't generate token")
		return
	}
	response.RespondWithJSON(w, http.StatusOK, struct {
		Token string `json:"token"`
	}{
		Token: signedToken,
	})
}
