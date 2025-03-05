package auth

import (
	"liveClass/helper"
)

type AuthRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *AuthRepository {
	return &AuthRepository{db: db}
}
