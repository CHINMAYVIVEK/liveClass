package instructor

import (
	"net/http"
)

func (h *Handler) DashboardPage(w http.ResponseWriter, r *http.Request) {
	// Add any dashboard-specific data here
	data := map[string]interface{}{}
	h.renderTemplate(w, "dashboard", data)
}
func (h *Handler) LiveClassPage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "live-class", data)
}
