package server

import (
	"liveClass/app/auth"
	"liveClass/app/student"
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
	authRepo := auth.NewRepository(s.db)
	authHandler := auth.NewHandler(authRepo)

	s.mux.HandleFunc("/api/auth/login", authHandler.Index)
}
