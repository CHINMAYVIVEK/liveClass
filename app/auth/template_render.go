package auth

import (
	"liveClass/helper"
	"net/http"
)

func (h *Handler) renderTemplate(w http.ResponseWriter, name string, data interface{}) {
	tmpl, err := helper.LoadTemplate(helper.WebsiteView, name)
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
