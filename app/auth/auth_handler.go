package auth

import (
	"encoding/json"
	"liveClass/helper"
	"net/http"
	"text/template"
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

	// Parse all templates together
	t, err := template.ParseFiles(
		"template/website/login.html",
		"template/website/_header.html",
		"template/website/_footer.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["login"] = t
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
	token, err := h.repo.Login(r.Context(), &loginRequest)
	if err != nil {
		helper.NewErrorResponse(w, http.StatusInternalServerError, err.Error())
		return
	}

	helper.NewSuccessResponse(w, token, "Login successful", http.StatusOK)
}
