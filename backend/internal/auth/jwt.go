package auth

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

const JWT_DURATION = (24 * 7 * 2) * time.Hour // token expired in 2 weeks

type JWTClaim struct {
	Username string `json:"username"`
	jwt.StandardClaims
}

func GenerateJWT(username string) (string, error) {
	jwtKey := []byte(os.Getenv("JWT_KEY"))
	expirationTime := time.Now().UTC().Add(JWT_DURATION)
	claims := &JWTClaim{
		Username: username,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtKey)
}

func ValidateToken(signedToken string) error {
	jwtKey := []byte(os.Getenv("JWT_KEY"))
	token, err := jwt.ParseWithClaims(
		signedToken,
		&JWTClaim{},
		func(t *jwt.Token) (interface{}, error) {
			return []byte(jwtKey), nil
		},
	)

	if err != nil {
		return err
	}

	claims, ok := token.Claims.(*JWTClaim)
	if !ok {
		return errors.New("Couldn't parse claims")
	}

	if claims.ExpiresAt < time.Now().UTC().Unix() {
		return errors.New("Token expired")
	}
	return nil
}

func GetUsernameFromToken(signedToken string) (string, error) {
	jwtKey := []byte(os.Getenv("JWT_KEY"))
	token, err := jwt.ParseWithClaims(
		signedToken,
		&JWTClaim{},
		func(t *jwt.Token) (interface{}, error) {
			return []byte(jwtKey), nil
		},
	)

	if err != nil {
		return "", err
	}

	claims, ok := token.Claims.(*JWTClaim)
	if !ok {
		return "", errors.New("Couldn't parse claims")
	}

	return claims.Username, nil
}
