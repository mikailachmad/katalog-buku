package apihandler

import (
	"bookshelf/utils"
	"net/http"
)

func HandlerHealthz(w http.ResponseWriter, r *http.Request) {
	utils.RespondWithJSON(w, 200, struct{}{})
}
