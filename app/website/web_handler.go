package website

// Add encoding/json to imports
import (
	"html/template"
	"liveClass/helper"
	"net/http"
)

type Handler struct {
	repo      *WebRepository
	templates map[string]*template.Template
}

func NewHandler(repo *WebRepository) *Handler {
	return &Handler{
		repo:      repo,
		templates: make(map[string]*template.Template),
	}
}

func (h *Handler) renderTemplate(w http.ResponseWriter, name string, data interface{}) {
	tmpl, err := helper.LoadTemplate(helper.WebsiteView, name, "template/website/"+name+".html")
	if err != nil {
		logger.Error("Error loading template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error loading template")
		return
	}

	if err := tmpl.ExecuteTemplate(w, name, data); err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}

func (h *Handler) IndexPage(w http.ResponseWriter, r *http.Request) {
	courses, err := h.repo.GetCourses()
	if err != nil {
		logger.Error("Error getting courses:", err)
	}
	h.renderTemplate(w, "index", map[string]interface{}{
		"Courses": courses,
		"Error":   err != nil,
	})
}
