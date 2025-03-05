package student

import (
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"

	"liveClass/helper"

	"github.com/google/uuid"
)

type Handler struct {
	repo *StudentRepository
}

func NewHandler(repo *StudentRepository) *Handler {
	return &Handler{repo: repo}
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
	fmt.Println("hare --1  ")
	id, err := uuid.Parse(idStr)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusBadRequest, err.Error())

		return
	}
	fmt.Println("hare --2  ")
	student, err := h.repo.GetByID(r.Context(), id)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}

	helper.NewSuccessResponse(w, student, "Student retrieved successfully", http.StatusOK)
}

func (h *Handler) DashboardPage(w http.ResponseWriter, r *http.Request) {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}

	t, err := helper.LoadTemplate(helper.StudentView, "dashboard.html",
		"template/lms_panel/student/dashboard.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["dashboard"] = t

	err = templates["dashboard"].ExecuteTemplate(w, "dashboard", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}
