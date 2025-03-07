package student

import (
	"html/template"
	"liveClass/helper"
	"net/http"
)

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

func (h *Handler) VideoPlayerPage(w http.ResponseWriter, r *http.Request) {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	t, err := helper.LoadTemplate(helper.StudentView, "videoplayer.html",
		"template/lms_panel/student/videoplayer.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["videoplayer"] = t
	err = templates["videoplayer"].ExecuteTemplate(w, "videoplayer", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}

func (h *Handler) LiveLecturePage(w http.ResponseWriter, r *http.Request) {
	if templates == nil {
		templates = make(map[string]*template.Template)
	}
	t, err := helper.LoadTemplate(helper.StudentView, "livelecture.html",
		"template/lms_panel/student/livelecture.html",
	)
	if err != nil {
		logger.Error(err)
		panic(err)
	}
	templates["livelecture"] = t
	err = templates["livelecture"].ExecuteTemplate(w, "livelecture", nil)
	if err != nil {
		logger.Error("Error executing template:", err)
		helper.NewErrorResponse(w, http.StatusInternalServerError, "Error executing template")
	}
}
