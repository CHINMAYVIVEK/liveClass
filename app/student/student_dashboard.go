package student

import (
	"html/template"
	"liveClass/helper"
	"net/http"
)

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
