package student

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"liveClass/helper"
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
	query := `
        INSERT INTO students (
             first_name, last_name, email, phone_number,
            password_hash, sso_provider, sso_provider_id, profile_picture_url,
            bio, date_of_birth, address, gender, social_media_handles,
            nationality, preferred_language
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
        RETURNING student_id`

	socialMediaJSON, err := json.Marshal(student.SocialMediaLinks)
	if err != nil {
		return fmt.Errorf("failed to marshal social media handles: %w", err)
	}

	_, err = r.db.Insert(ctx, query,
		student.FirstName, student.LastName, student.Email,
		student.PhoneNumber, student.PasswordHash, student.SSOProvider,
		student.SSOProviderID, student.ProfilePictureURL, student.Bio,
		student.DateOfBirth, student.Address, student.Gender, socialMediaJSON,
		student.Nationality, student.PreferredLanguage,
	)
	return err
}

func (r *StudentRepository) GetByID(ctx context.Context, id uuid.UUID) (*Student, error) {
	// Create a context with timeout
	queryCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	query := `SELECT 
        student_id,
        COALESCE(first_name, ''),
        COALESCE(last_name, ''),
        COALESCE(email, ''),
        COALESCE(phone_number, ''),
        COALESCE(bio, ''),
        COALESCE(date_of_birth, NULL),
        COALESCE(address, ''),
        COALESCE(gender, ''),
        COALESCE(social_media_handles, '{}'),
        COALESCE(nationality, ''),
        COALESCE(preferred_language, ''),
        created_at,
        updated_at
    FROM students WHERE student_id = $1`

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
