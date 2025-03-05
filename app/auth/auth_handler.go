package auth

import (
	"fmt"
	"html/template"
	"net/http"
)

type Handler struct {
	repo *AuthRepository
}

func NewHandler(repo *AuthRepository) *Handler {
	return &Handler{repo: repo}
}

var templates map[string]*template.Template

func init() {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}

	// Parse all templates together
	t, err := template.ParseFiles(
		"template/website/index.html",
		"template/website/_header.html",
		"template/website/_footer.html",
	)
	if err != nil {
		panic(err)
	}
	templates["index"] = t
}

func (h *Handler) Index(w http.ResponseWriter, r *http.Request) {
	err := templates["index"].ExecuteTemplate(w, "index", nil)
	if err != nil {
		fmt.Println("Error executing template:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
