package student

import (
	"html/template"
	"liveClass/helper"
	"net/http"
)

func (h *Handler) SchedulePage(w http.ResponseWriter, r *http.Request) {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	t, err := helper.LoadTemplate(helper.StudentView, "schedule.html",
		"template/lms_panel/student/schedule.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["schedule"] = t
	err = templates["schedule"].ExecuteTemplate(w, "schedule", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}
