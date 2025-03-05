package student

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"liveClass/helper"
	"strings"
	"time"

	"github.com/google/uuid"
)

type StudentRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *StudentRepository {
	return &StudentRepository{db: db}
}

func (r *StudentRepository) Create(ctx context.Context, student *Student) error {
	// Input validation
	if err := r.validateStudentInput(student); err != nil {
		return fmt.Errorf("invalid student data: %w", err)
	}

	// Start transaction
	tx, err := r.db.BeginTx(ctx)
	if err != nil {
		return fmt.Errorf("failed to start transaction: %w", err)
	}
	defer func() {
		if err != nil {
			if rbErr := tx.Rollback(); rbErr != nil {
				err = fmt.Errorf("tx failed: %v, rollback failed: %v", err, rbErr)
			}
			return
		}
		if err = tx.Commit(); err != nil {
			err = fmt.Errorf("failed to commit transaction: %w", err)
		}
	}()

	// Insert into users table
	userQuery := `
        INSERT INTO users (
            first_name, last_name, email, phone_number,
            password_hash, sso_provider, sso_provider_id, profile_picture_url,
            bio, date_of_birth, address, gender, social_media_handles,
            nationality, preferred_language
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
        RETURNING user_id`

	socialMediaJSON, err := json.Marshal(student.SocialMediaLinks)
	if err != nil {
		return fmt.Errorf("failed to marshal social media handles: %w", err)
	}

	var userID uuid.UUID
	err = tx.QueryRow(ctx, userQuery,
		student.FirstName, student.LastName, student.Email,
		student.PhoneNumber, student.PasswordHash, student.SSOProvider,
		student.SSOProviderID, student.ProfilePictureURL, student.Bio,
		student.DateOfBirth, student.Address, student.Gender, socialMediaJSON,
		student.Nationality, student.PreferredLanguage,
	).Scan(&userID)
	if err != nil {
		if helper.IsPgUniqueViolation(err) {
			return helper.ErrDuplicateEmail
		}
		return fmt.Errorf("failed to insert user: %w", err)
	}

	// Insert into students table
	studentQuery := `
        INSERT INTO students (user_id)
        VALUES ($1)
        RETURNING student_id`

	err = tx.QueryRow(ctx, studentQuery, userID).Scan(&student.ID)
	if err != nil {
		return fmt.Errorf("failed to insert student: %w", err)
	}

	// Assign student role
	roleQuery := `
        INSERT INTO user_roles (user_id, role_id)
        SELECT $1, role_id FROM roles WHERE role_name = 'student'`

	result, err := tx.Exec(ctx, roleQuery, userID)
	if err != nil {
		return fmt.Errorf("failed to assign student role: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get affected rows: %w", err)
	}
	if rowsAffected == 0 {
		return helper.ErrStudentRoleNotFound
	}

	return nil
}

// Add these helper functions and types

func (r *StudentRepository) validateStudentInput(student *Student) error {
	if student == nil {
		return fmt.Errorf("%w: student is nil", helper.ErrInvalidInput)
	}

	// Validate required fields
	if strings.TrimSpace(student.Email) == "" {
		return fmt.Errorf("%w: email is required", helper.ErrInvalidInput)
	}
	if !helper.PatternValidation(helper.PatternTypeEmail, student.Email) {
		return fmt.Errorf("%w: invalid email format", helper.ErrInvalidInput)
	}

	if strings.TrimSpace(student.FirstName) == "" {
		return fmt.Errorf("%w: first name is required", helper.ErrInvalidInput)
	}

	return nil
}

func (r *StudentRepository) GetByID(ctx context.Context, id uuid.UUID) (*Student, error) {
	queryCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	query := `
        SELECT 
            s.student_id,
            COALESCE(u.first_name, ''),
            COALESCE(u.last_name, ''),
            COALESCE(u.email, ''),
            COALESCE(u.phone_number, ''),
            COALESCE(u.bio, ''),
            COALESCE(u.date_of_birth, NULL),
            COALESCE(u.address, ''),
            COALESCE(u.gender, ''),
            COALESCE(u.social_media_handles, '{}'),
            COALESCE(u.nationality, ''),
            COALESCE(u.preferred_language, ''),
            u.created_at,
            u.updated_at,
            u.password_hash,
            u.sso_provider,
            u.sso_provider_id,
            u.profile_picture_url
        FROM students s
        JOIN users u ON s.user_id = u.user_id
        WHERE s.student_id = $1`

	// Use queryCtx instead of ctx
	row, err := r.db.QueryRow(queryCtx, query, id)
	if err != nil {
		if err == context.Canceled {
			return nil, fmt.Errorf("query canceled: %w", err)
		}
		return nil, fmt.Errorf("error querying student: %w", err)
	}

	var student Student
	var socialMediaJSON []byte
	var dateOfBirth sql.NullTime

	// Use queryCtx for scanning
	if err := row.Scan(
		&student.ID,
		&student.FirstName,
		&student.LastName,
		&student.Email,
		&student.PhoneNumber,
		&student.Bio,
		&dateOfBirth,
		&student.Address,
		&student.Gender,
		&socialMediaJSON,
		&student.Nationality,
		&student.PreferredLanguage,
		&student.CreatedAt,
		&student.UpdatedAt,
	); err != nil {
		if err == context.Canceled {
			return nil, fmt.Errorf("scan canceled: %w", err)
		}
		return nil, fmt.Errorf("failed to scan student: %w", err)
	}

	// Rest of the code remains the same
	if dateOfBirth.Valid {
		student.DateOfBirth = &dateOfBirth.Time
	}

	if len(socialMediaJSON) > 0 && string(socialMediaJSON) != "{}" {
		student.SocialMediaLinks = &SocialMediaHandles{}
		if err := json.Unmarshal(socialMediaJSON, student.SocialMediaLinks); err != nil {
			return nil, fmt.Errorf("failed to unmarshal social media handles: %w", err)
		}
	}

	return &student, nil
}
