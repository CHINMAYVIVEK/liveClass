package student

import (
	"net/http"
)

func (h *Handler) getCurrentUser() Student {
	return Student{
		ID:                "123",
		Email:             "testuser@gmail.com",
		FirstName:         "Chinmay",
		LastName:          "Vivek",
		ProfilePictureURL: "https://img.freepik.com/free-vector/young-man-orange-hoodie_1308-175788.jpg",
	}
}

func (h *Handler) DashboardPage(w http.ResponseWriter, r *http.Request) {
	// Get session
	// Check if user is authenticated

	data := map[string]interface{}{
		"UserData": h.getCurrentUser(),
	}
	h.renderTemplate(w, "dashboard", data)
}
