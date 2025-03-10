package student

import (
	"net/http"
)

func (h *Handler) DashboardPage(w http.ResponseWriter, r *http.Request) {
	// Get session
	// Check if user is authenticated

	data := map[string]interface{}{}
	h.renderTemplate(w, "dashboard", data)
}
