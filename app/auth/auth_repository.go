package auth

import (
	"context"
	"liveClass/helper"
)

type AuthRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *AuthRepository {
	return &AuthRepository{db: db}
}

func (r *AuthRepository) Login(ctx context.Context, login *LoginRequest) (*LoginResponse, error) {
	var user LoginResponse
	return &user, nil
}
