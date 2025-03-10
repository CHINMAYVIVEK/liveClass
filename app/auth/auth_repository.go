package auth

import (
	"context"

	"github.com/CHINMAYVIVEK/liveClass/helper"
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

func (r *AuthRepository) GetUserRoleByEmail(ctx context.Context, email string) (string, error) {
	var role string
	query := `SELECT role FROM users WHERE email = $1`
	row, err := r.db.QueryRow(ctx, query, email)
	if err != nil {
		return "", err
	}
	err = row.Scan(&role)
	if err != nil {
		return "", err
	}
	return role, nil
}
