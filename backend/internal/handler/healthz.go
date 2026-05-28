package handler

import (
	"bookshelf/internal/response"
	"net/http"
)

func Healthz(w http.ResponseWriter, r *http.Request) {
	response.RespondWithJSON(w, http.StatusOK, struct{}{})
}
