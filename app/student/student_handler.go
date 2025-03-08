package student

import (
	"encoding/json"
	"html/template"
	"net/http"

	"liveClass/helper"

	"github.com/google/uuid"
)

type Handler struct {
	repo      *StudentRepository
	templates map[string]*template.Template
}

func NewHandler(repo *StudentRepository) *Handler {
	return &Handler{
		repo:      repo,
		templates: make(map[string]*template.Template),
	}
}

var logger = helper.GetLogger()
var templates map[string]*template.Template

func (h *Handler) CreateStudent(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	var student Student
	if err := json.NewDecoder(r.Body).Decode(&student); err != nil {
		helper.NewErrorResponse(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if err := h.repo.Create(r.Context(), &student); err != nil {
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Failed to create student")
		return
	}

	helper.NewSuccessResponse(w, student, "Student created successfully", http.StatusCreated)
}

func (h *Handler) GetStudent(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	idStr := r.URL.Query().Get("id")

	id, err := uuid.Parse(idStr)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusBadRequest, err.Error())

		return
	}
	student, err := h.repo.GetByID(r.Context(), id)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}

	helper.NewSuccessResponse(w, student, "Student retrieved successfully", http.StatusOK)
}
