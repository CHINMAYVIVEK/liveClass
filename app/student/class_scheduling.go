package student

import (
	"net/http"
)

func (h *Handler) SchedulePage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "schedule", data)
}
