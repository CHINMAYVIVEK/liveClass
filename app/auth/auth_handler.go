package auth

import (
	"encoding/json"
	"html/template"
	"liveClass/helper"
	"net/http"
)

type Handler struct {
	repo *AuthRepository
}

func NewHandler(repo *AuthRepository) *Handler {
	return &Handler{repo: repo}
}

var logger = helper.GetLogger()

var templates map[string]*template.Template

func init() {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}

	t, err := helper.LoadTemplate(helper.WebsiteView, "login.html",
		"template/website/login.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["login"] = t
}

func (h *Handler) LoginPage(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	err := templates["login"].ExecuteTemplate(w, "login", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	var loginRequest LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&loginRequest); err != nil {
		helper.NewErrorResponse(w, http.StatusBadRequest, "Invalid request body")
		return
	}
	loginResponse, err := h.repo.Login(r.Context(), &loginRequest)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}
	if loginResponse.User.Role == string(AdminRole) {
		helper.NewSuccessResponse(w, loginResponse, "Admin Login successful", http.StatusOK)
		return
	} else if loginResponse.User.Role == string(InstructorRole) {
		helper.NewSuccessResponse(w, loginResponse, "Instructor Login successful", http.StatusOK)
		return

	} else if loginResponse.User.Role == string(StudentRole) {
		helper.NewSuccessResponse(w, loginResponse, "Student Login successful", http.StatusOK)

	}
	helper.NewErrorResponse(w, http.StatusUnauthorized, "Invalid credentials")
}

func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}
	helper.NewSuccessResponse(w, nil, "Logout successful", http.StatusOK)
}
