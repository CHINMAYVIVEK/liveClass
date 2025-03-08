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
	s.mux.HandleFunc("/student/dashboard", studentHandler.DashboardPage)
	s.mux.HandleFunc("/student/schedule", studentHandler.SchedulePage)
	s.mux.HandleFunc("/student/recordings", studentHandler.RecordingPage)
	s.mux.HandleFunc("/student/video", studentHandler.VideoPlayerPage)
	s.mux.HandleFunc("/student/live-lecture", studentHandler.LiveLecturePage)
	s.mux.HandleFunc("/student/performance", studentHandler.PerformancePage)
	s.mux.HandleFunc("/student/notes", studentHandler.NotesPage)
	s.mux.HandleFunc("/student/assignments", studentHandler.AssignmentsPage)

	// Add more routes as needed
	webRepo := website.NewRepository(s.db)
	webHandler := website.NewHandler(webRepo)

	s.mux.HandleFunc("/", webHandler.IndexPage)
	s.mux.HandleFunc("/programs", webHandler.ProgramsPage)
	s.mux.HandleFunc("/instructors", webHandler.InstructorsPage)

	authRepo := auth.NewRepository(s.db)
	authHandler := auth.NewHandler(authRepo)

	s.mux.HandleFunc("/login", authHandler.LoginPage)
	s.mux.HandleFunc("/api/login", authHandler.Login)
	s.mux.HandleFunc("/api/logout", authHandler.Logout)

}
