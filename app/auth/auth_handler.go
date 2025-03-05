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
	fmt.Println("init auth handler")
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	// Parse template with a name
	templates["index.html"] = template.Must(template.New("index.html").ParseFiles("template/index.html"))
}

func (h *Handler) Index(w http.ResponseWriter, r *http.Request) {
	// Use the template name "index" instead of the full path
	err := templates["index.html"].ExecuteTemplate(w, "index.html", map[string]template.JS{})
	if err != nil {
		fmt.Println("Error executing template:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
