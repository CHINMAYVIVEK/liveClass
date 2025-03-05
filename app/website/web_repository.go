package website

import (
	"liveClass/helper"
)

type WebRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *WebRepository {
	return &WebRepository{db: db}
}
