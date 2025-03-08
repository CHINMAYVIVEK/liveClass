package instructor

import (
	"time"
)

type SocialMediaHandle struct {
	LinkedIn string `json:"linkedin,omitempty"`
	Twitter  string `json:"twitter,omitempty"`
	GitHub   string `json:"github,omitempty"`
	Website  string `json:"website,omitempty"`
}

type Instructor struct {
	InstructorID      string            `json:"instructor_id"`
	UserID            string            `json:"user_id"`
	FirstName         string            `json:"first_name"`
	LastName          string            `json:"last_name"`
	Email             string            `json:"email"`
	PhoneNumber       string            `json:"phone_number,omitempty"`
	ProfilePictureURL string            `json:"profile_picture_url,omitempty"`
	Bio               string            `json:"bio,omitempty"`
	DateOfBirth       *time.Time        `json:"date_of_birth,omitempty"`
	Gender            string            `json:"gender,omitempty"`
	SocialMedia       SocialMediaHandle `json:"social_media_handles,omitempty"`
	Nationality       string            `json:"nationality,omitempty"`
	PreferredLanguage string            `json:"preferred_language,omitempty"`
	CreatedAt         time.Time         `json:"created_at"`
	UpdatedAt         time.Time         `json:"updated_at"`

	Qualifications    string `json:"qualifications,omitempty"`
	YearsOfExperience int    `json:"experience,omitempty"`

	FullName       string `json:"name"`
	TotalStudents  int    `json:"students"`
	Specialization string `json:"specialization"`
}
