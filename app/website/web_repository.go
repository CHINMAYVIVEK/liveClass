package website

import (
	"context"
	"liveClass/helper"
)

type WebRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *WebRepository {
	return &WebRepository{db: db}
}

func (r *WebRepository) GetCourses(ctx context.Context) ([]Course, error) {
	var courses []Course
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
		return nil, err
	}
	defer rows.Close()

	if ctx.Err() != nil {
		return nil, ctx.Err()
	}

	for rows.Next() {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}

		var course Course
		err := rows.Scan(
			&course.CourseID,
			&course.Title,
			&course.Description,
			&course.Image,
			&course.IsActive,
			&course.SequenceNo,
			&course.CoursePrice,
			&course.CourseLevel,
			&course.CourseType.CourseTypeID,
			&course.CourseType.CourseType,
		)
		if err != nil {
			return nil, err
		}
		courses = append(courses, course)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return courses, nil
}

func (r *WebRepository) GetCourseById() error {
	return nil
}
func (r *WebRepository) GetInstructors() error {
	return nil
}
