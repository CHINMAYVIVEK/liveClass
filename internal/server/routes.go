package server

import (
	"liveClass/app/auth"
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
	s.mux.HandleFunc("/dashboard", studentHandler.DashboardPage)
	s.mux.HandleFunc("/schedule", studentHandler.SchedulePage)
	s.mux.HandleFunc("/recordings", studentHandler.RecordingPage)
	s.mux.HandleFunc("/video", studentHandler.VideoPlayerPage)
	s.mux.HandleFunc("/live-lecture", studentHandler.LiveLecturePage)

	// Add more routes as needed
	webRepo := website.NewRepository(s.db)
	webHandler := website.NewHandler(webRepo)

	s.mux.HandleFunc("/", webHandler.Index)

	authRepo := auth.NewRepository(s.db)
	authHandler := auth.NewHandler(authRepo)

	s.mux.HandleFunc("/login", authHandler.LoginPage)
	s.mux.HandleFunc("/api/login", authHandler.Login)
	s.mux.HandleFunc("/api/logout", authHandler.Logout)

}
