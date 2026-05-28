package middleware

import (
	"bookshelf/internal/auth"
	"bookshelf/internal/response"
	"context"
	"net/http"
)

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		tokenString := r.Header.Get("Authorization")
		if tokenString == "" {
			response.RespondWithError(w, http.StatusUnauthorized, "Request does not contain an access token")
			return
		}
		err := auth.ValidateToken(tokenString)
		if err != nil {
			response.RespondWithError(w, http.StatusUnauthorized, err.Error())
			return
		}

		username, err := auth.GetUsernameFromToken(tokenString)
		if err != nil {
			response.RespondWithError(w, http.StatusInternalServerError, err.Error())
			return
		}

		ctx := context.WithValue(r.Context(), "username", username)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
