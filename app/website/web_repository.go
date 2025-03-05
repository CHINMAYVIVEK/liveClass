package website

import (
	"context"
	"fmt"
	"liveClass/helper"
)

type WebRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *WebRepository {
	return &WebRepository{db: db}
}

func (r *WebRepository) GetCourses() ([]Course, error) {
	var courses []Course
	ctx := context.Context(context.Background())
	query := `
        SELECT 
            c.course_id,
            c.title,
            c.description,
            c.image,
            c.is_active,
            c.sequence_no,
            c.course_price,
            c.course_level,
            ct.type_id,
            ct.type_name
        FROM courses c
        LEFT JOIN course_types ct ON c.course_type_id = ct.type_id
        WHERE c.is_active = true
        ORDER BY c.sequence_no ASC`

	rows, err := r.db.Query(ctx, query)
	if err != nil {
		logger.Error(err)
		return nil, fmt.Errorf("failed to execute query: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var course Course
		typeID := ""
		typeName := ""
		err := rows.Scan(
			&course.CourseID,
			&course.Title,
			&course.Description,
			&course.Image,
			&course.IsActive,
			&course.SequenceNo,
			&course.CoursePrice,
			&course.CourseLevel,
			&typeID,
			&typeName,
		)
		if err != nil {
			logger.Error(err)
			return nil, fmt.Errorf("failed to scan course: %w", err)
		}
		course.CourseType = CourseType{
			CourseTypeID: typeID,
			CourseType:   typeName,
		}

		courses = append(courses, course)
	}

	// fmt.Printf("courses: %+v\n", courses)

	// Check for errors from iterating over rows
	if err = rows.Err(); err != nil {
		logger.Error(err)
		return nil, fmt.Errorf("error iterating over rows: %w", err)
	}

	return courses, nil
}

func (r *WebRepository) GetCourseById() error {
	return nil
}
func (r *WebRepository) GetInstructors() error {
	return nil
}
