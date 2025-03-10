package website

import (
	"fmt"
	"strconv"

	"github.com/CHINMAYVIVEK/liveClass/helper"
)

type WebRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *WebRepository {
	return &WebRepository{db: db}
}

func (r *WebRepository) GetInstructors(page, limit string) ([]Instructors, error) {
	var (
		limitClause = "8" // default limit
		currentPage = "1" // default page
		offset      int
	)

	if limit != "" {
		limitClause = limit
	}
	if page != "" {
		currentPage = page
	}

	// Convert string to int for calculation
	pageNum, err := strconv.Atoi(currentPage)
	if err != nil {
		return nil, fmt.Errorf("invalid page number: %w", err)
	}
	limitNum, err := strconv.Atoi(limitClause)
	if err != nil {
		return nil, fmt.Errorf("invalid limit number: %w", err)
	}

	offset = (pageNum - 1) * limitNum

	fmt.Println("offset:", offset)
	var instructors []Instructors

	return instructors, nil
}
