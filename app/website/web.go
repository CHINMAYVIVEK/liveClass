package website

import (
	"github.com/google/uuid"
)

type Course struct {
	CourseID    uuid.UUID  `json:"course_id" db:"course_id"`
	Title       string     `json:"title" db:"title"`
	Description string     `json:"description" db:"description"`
	Image       string     `json:"image" db:"image"`
	IsActive    bool       `json:"is_active" db:"is_active"`
	SequenceNo  int        `json:"sequence_no" db:"sequence_no"`
	CoursePrice string     `json:"price" db:"course_price"`
	CourseType  CourseType `json:"course_type" db:"course_type"`
	CourseLevel string     `json:"course_level" db:"course_level"`
}

type CourseType struct {
	CourseTypeID uuid.UUID `json:"course_type_id" db:"course_type_id"`
	CourseType   string    `json:"course_type" db:"course_type"`
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
