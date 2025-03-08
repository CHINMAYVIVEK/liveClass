package website

import "liveClass/helper"

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

type Instructors struct {
	InstructorID string `json:"instructor_id"`
	FirstName    string `json:"first_name"`
	LastName     string `json:"last_name"`
	Image        string `json:"image"`
	IsActive     bool   `json:"is_active"`
	SequenceNo   int    `json:"sequence_no"`
}
