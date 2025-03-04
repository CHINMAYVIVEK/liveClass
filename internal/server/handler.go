package server

import (
	"liveClass/helper"
	"net/http"
)

// Route handlers
func (s *Server) handleHealthCheck(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		helper.NewErrorResponse(w, http.StatusMethodNotAllowed, "Method not allowed")

		return
	}

	healthData := map[string]string{
		"status": "healthy",
	}
	helper.NewSuccessResponse(w, healthData, "Server is running", http.StatusOK)

}
