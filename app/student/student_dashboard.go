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

func (h *Handler) RecordingPage(w http.ResponseWriter, r *http.Request) {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	t, err := helper.LoadTemplate(helper.StudentView, "recordings.html",
		"template/lms_panel/student/recordings.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["recordings"] = t
	err = templates["recordings"].ExecuteTemplate(w, "recordings", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}
