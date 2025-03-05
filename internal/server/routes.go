package server

import (
	"liveClass/app/student"
	"liveClass/app/website"
)

// SetupRoutes initializes all the routes for the server
func (s *Server) SetupRoutes() {
	// Health Check Route
	s.mux.HandleFunc("/api/health", s.handleHealthCheck)

	// Student Routes
	studentRepo := student.NewRepository(s.db)
	studentHandler := student.NewHandler(studentRepo)

	s.mux.HandleFunc("/api/students", studentHandler.CreateStudent)
	s.mux.HandleFunc("/api/students/get", studentHandler.GetStudent)

	// Add more routes as needed
	WebRepo := website.NewRepository(s.db)
	WebHandler := website.NewHandler(WebRepo)

	s.mux.HandleFunc("/", WebHandler.Index)
}
