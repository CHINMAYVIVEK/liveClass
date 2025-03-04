package student

import (
	"time"

	"github.com/google/uuid"
)

type SocialMediaHandles struct {
	Facebook  string `json:"facebook"`
	Twitter   string `json:"twitter"`
	LinkedIn  string `json:"linkedin"`
	Instagram string `json:"instagram"`
	GitHub    string `json:"github"`
}

type Student struct {
	ID                uuid.UUID           `json:"id"`
	FirstName         string              `json:"firstName"`
	LastName          *string             `json:"lastName"`
	Email             string              `json:"email"`
	PhoneNumber       *string             `json:"phoneNumber"`
	PasswordHash      *string             `json:"-"`
	SSOProvider       *string             `json:"ssoProvider"`
	SSOProviderID     *string             `json:"ssoProviderId"`
	ProfilePictureURL *string             `json:"profilePictureUrl"`
	Bio               *string             `json:"bio"`
	DateOfBirth       *time.Time          `json:"dateOfBirth"`
	Address           *string             `json:"address"`
	Gender            *string             `json:"gender"`
	SocialMediaLinks  *SocialMediaHandles `json:"socialMediaHandles"`
	Nationality       *string             `json:"nationality"`
	PreferredLanguage *string             `json:"preferredLanguage"`
	CreatedAt         time.Time           `json:"createdAt"`
	UpdatedAt         time.Time           `json:"updatedAt"`
}
