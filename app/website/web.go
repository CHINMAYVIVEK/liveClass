package website

import (
	"liveClass/helper"
	"time"
)

var logger = helper.GetLogger()

type Course struct {
	CourseID    string     `json:"course_id"`
	Title       string     `json:"title"`
	Description string     `json:"description"`
	Image       string     `json:"image"`
	IsActive    bool       `json:"is_active"`
	SequenceNo  int        `json:"sequence_no"`
	CoursePrice string     `json:"course_price"`
	CourseType  CourseType `json:"course_type"`
	CourseLevel string     `json:"course_level"`
}

type CourseType struct {
	CourseTypeID string `json:"course_type_id"`
	CourseType   string `json:"course_type"`
}

var CourseLevels = map[string]string{
	"beginner":     "Beginner",
	"intermediate": "Intermediate",
	"advanced":     "Advanced",
}

// type CourseLevel struct {
// 	CourseLevelID uuid.UUID `json:"course_level_id" db:"course_level_id"`
// 	CourseLevel   string    `json:"course_level" db:"course_level"`
// }

type SocialMediaHandles struct {
	LinkedIn string `json:"linkedin,omitempty"`
	Twitter  string `json:"twitter,omitempty"`
	GitHub   string `json:"github,omitempty"`
	Website  string `json:"website,omitempty"`
}

type Instructors struct {
	InstructorID      string             `json:"instructor_id"`
	UserID            string             `json:"user_id"`
	FirstName         string             `json:"first_name"`
	LastName          string             `json:"last_name"`
	Email             string             `json:"email"`
	PhoneNumber       string             `json:"phone_number,omitempty"`
	ProfilePictureURL string             `json:"profile_picture_url,omitempty"`
	Bio               string             `json:"bio,omitempty"`
	DateOfBirth       *time.Time         `json:"date_of_birth,omitempty"`
	Gender            string             `json:"gender,omitempty"`
	SocialMedia       SocialMediaHandles `json:"social_media_handles,omitempty"`
	Nationality       string             `json:"nationality,omitempty"`
	PreferredLanguage string             `json:"preferred_language,omitempty"`
	CreatedAt         time.Time          `json:"created_at"`
	UpdatedAt         time.Time          `json:"updated_at"`

	// Instructor-specific fields
	Qualifications    string `json:"qualifications,omitempty"`
	YearsOfExperience int    `json:"experience,omitempty"`

	// Computed fields for the UI
	FullName       string `json:"name"`
	TotalStudents  int    `json:"students"`
	Specialization string `json:"specialization"`
}
