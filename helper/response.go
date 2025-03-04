package helper

import (
	"encoding/json"
	"net/http"
	"time"
)

// Response represents the standard API response structure
type Response struct {
	Success    bool        `json:"success"`
	Message    string      `json:"message"`
	Data       interface{} `json:"data,omitempty"`
	StatusCode int         `json:"status_code"`
	Timestamp  string      `json:"timestamp"`
}

// NewResponse creates a base response with common fields
func newBaseResponse(statusCode int, message string) Response {
	return Response{
		Timestamp:  time.Now().UTC().Format(time.RFC3339),
		StatusCode: statusCode,
		Message:    message,
	}
}

// NewSuccessResponse creates a success response
func NewSuccessResponse(w http.ResponseWriter, data interface{}, message string, statusCode int) {
	resp := newBaseResponse(statusCode, message)
	resp.Success = true
	resp.Data = data

	sendJSONResponse(w, resp)
}

// NewErrorResponse creates an error response
func NewErrorResponse(w http.ResponseWriter, code int, message string) {
	resp := newBaseResponse(code, message)
	resp.Success = false
	sendJSONResponse(w, resp)
}

func sendJSONResponse(w http.ResponseWriter, response Response) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(response.StatusCode)
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
	}
}
