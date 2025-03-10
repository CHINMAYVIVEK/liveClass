package student

import (
	"context"
	"encoding/json"
	"errors"
	"html/template"
	"net/http"
	"time"

	"github.com/CHINMAYVIVEK/liveClass/helper"

	"github.com/google/uuid"
)

var (
	ErrInvalidInput    = errors.New("invalid input")
	ErrStudentNotFound = errors.New("student not found")
	contextTimeout     = 5 * time.Second
)

type Handler struct {
	repo      *StudentRepository
	templates map[string]*template.Template
}

func NewHandler(repo *StudentRepository) *Handler {
	if repo == nil {
		panic("student repository is required")
	}
	return &Handler{
		repo:      repo,
		templates: make(map[string]*template.Template),
	}
}

var logger = helper.GetLogger()

func (s *Student) Validate() error {
	if s.FirstName == "" {
		return errors.New("student name is required")
	}
	if s.Email == "" {
		return errors.New("student email is required")
	}
	if !helper.IsValidPattern(helper.PatternTypeEmail, s.Email) {
		return errors.New("invalid email format")
	}

	return nil
}

func (h *Handler) CreateStudent(w http.ResponseWriter, r *http.Request) {
	logger.Info("handling create student request")
	defer r.Body.Close()

	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()

	if r.Method != http.MethodPost {
		logger.Error("method not allowed", "method", r.Method)
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	var student Student
	if err := json.NewDecoder(r.Body).Decode(&student); err != nil {
		logger.Error("failed to decode request body", "error", err)
		helper.NewErrorResponse(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if err := student.Validate(); err != nil {
		logger.Error("invalid student data", "error", err)
		helper.NewErrorResponse(w, http.StatusBadRequest, err.Error())
		return
	}

	if err := h.repo.Create(ctx, &student); err != nil {
		logger.Error("failed to create student", "error", err)
		statusCode := http.StatusInternalServerError
		if errors.Is(err, ErrInvalidInput) {
			statusCode = http.StatusBadRequest
		}
		helper.NewErrorResponse(w, statusCode, err.Error())
		return
	}

	logger.Info("student created successfully", "id", student.ID)
	helper.NewSuccessResponse(w, student, "Student created successfully", http.StatusCreated)
}

func (h *Handler) GetStudent(w http.ResponseWriter, r *http.Request) {
	logger.Info("handling get student request")

	ctx, cancel := context.WithTimeout(r.Context(), contextTimeout)
	defer cancel()

	if r.Method != http.MethodGet {
		logger.Error("method not allowed", "method", r.Method)
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	idStr := r.URL.Query().Get("id")
	if idStr == "" {
		logger.Error("missing student ID")
		helper.NewErrorResponse(w, http.StatusBadRequest, "Student ID is required")
		return
	}

	id, err := uuid.Parse(idStr)
	if err != nil {
		logger.Error("invalid student ID format", "error", err)
		helper.NewErrorResponse(w, http.StatusBadRequest, "Invalid student ID format")
		return
	}

	student, err := h.repo.GetByID(ctx, id)
	if err != nil {
		logger.Error("failed to get student", "error", err, "id", id)
		statusCode := http.StatusInternalServerError
		if errors.Is(err, ErrStudentNotFound) {
			statusCode = http.StatusNotFound
		}
		helper.NewErrorResponse(w, statusCode, err.Error())
		return
	}

	logger.Info("student retrieved successfully", "id", id)
	helper.NewSuccessResponse(w, student, "Student retrieved successfully", http.StatusOK)
}
