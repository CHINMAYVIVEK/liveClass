package website

import (
	"context"
	"fmt"
	"strconv"
)

func (r *WebRepository) GetCourses(page, limit string) ([]Course, error) {
	var (
		limitClause = "8" // default limit
		currentPage = "1" // default page
		offset      int
	)

	if limit != "" {
		limitClause = limit
	}
	if page != "" {
		currentPage = page
	}

	// Convert string to int for calculation
	pageNum, err := strconv.Atoi(currentPage)
	if err != nil {
		return nil, fmt.Errorf("invalid page number: %w", err)
	}
	limitNum, err := strconv.Atoi(limitClause)
	if err != nil {
		return nil, fmt.Errorf("invalid limit number: %w", err)
	}

	offset = (pageNum - 1) * limitNum

	ctx := context.Background()
	query := fmt.Sprintf(`
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
        ORDER BY c.sequence_no ASC
        LIMIT %d OFFSET %d`, limitNum, offset)

	rows, err := r.db.Query(ctx, query)
	if err != nil {
		logger.Error(err)
		return nil, fmt.Errorf("failed to execute query: %w", err)
	}
	defer rows.Close()

	var courses []Course
	for rows.Next() {
		var course Course
		typeID := ""
		typeName := ""
		scanErr := rows.Scan(
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
		if scanErr != nil {
			logger.Error(scanErr)
			return nil, fmt.Errorf("failed to scan course: %w", scanErr)
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
