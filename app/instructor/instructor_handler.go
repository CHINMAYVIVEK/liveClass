package instructor

import (
	"errors"
	"html/template"
	"liveClass/helper"
)

var (
	ErrInvalidInput    = errors.New("invalid input")
	ErrStudentNotFound = errors.New("student not found")
	logger             = helper.GetLogger()
)

type Handler struct {
	repo      *InstructorRepository
	templates map[string]*template.Template
}

func NewHandler(repo *InstructorRepository) *Handler {
	if repo == nil {
		panic("student repository is required")
	}
	return &Handler{
		repo:      repo,
		templates: make(map[string]*template.Template),
	}
}
