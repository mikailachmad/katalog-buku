package handler

import (
	"bookshelf/internal/response"
	"encoding/json"
	"net/http"
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
	}
}
