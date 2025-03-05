package website

// Add encoding/json to imports
import (
	"html/template"
	"liveClass/helper"
	"net/http"
)

type Handler struct {
	repo *WebRepository
}

func NewHandler(repo *WebRepository) *Handler {
	return &Handler{repo: repo}
}

var templates map[string]*template.Template

func init() {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}

	// t, err := helper.LoadTemplate("index.html",
	// 	"template/website/index.html",
	// 	"template/website/_header.html",
	// 	"template/website/_footer.html",
	// )

	t, err := helper.LoadTemplate("index.html",
		"template/website/index.html",
	)

	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["index"] = t
}

func (h *Handler) Index(w http.ResponseWriter, r *http.Request) {

	courses, err := h.repo.GetCourses()
	if err != nil {
		logger.Error("Error getting courses:", err)
		// Still render the template but with error state
		err = templates["index"].ExecuteTemplate(w, "index", map[string]interface{}{
			"Error": true,
		})
		if err != nil {
			logger.Error("Error executing template:", err)
			helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
		}
		return
	}

	// jsonData, err := json.Marshal(courses)
	// if err != nil {
	// 	logger.Error("Error executing template:", err)
	// 	helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	// }
	err = templates["index"].ExecuteTemplate(w, "index", map[string]interface{}{
		"Courses": courses,
		"Error":   false,
	})
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
		return
	}
}
