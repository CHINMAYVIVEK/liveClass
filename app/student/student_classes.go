package student

import (
	"net/http"
)

func (h *Handler) SchedulePage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "schedule", data)
}

func (h *Handler) RecordingPage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "recordings", data)
}

func (h *Handler) VideoPlayerPage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "videoplayer", data)
}

func (h *Handler) LiveLecturePage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "livelecture", data)
}
func (h *Handler) PerformancePage(w http.ResponseWriter, r *http.Request) {
	data := map[string]interface{}{}
	h.renderTemplate(w, "performance", data)
}
