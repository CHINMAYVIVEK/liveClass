package auth

import (
	"time"

	"github.com/google/uuid"
)

// LoginRequest represents the login credentials
type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password,omitempty"`
}

// LoginResponse represents the response after successful login
type LoginResponse struct {
	Token        string    `json:"token"`
	RefreshToken string    `json:"refreshToken"`
	ExpiresAt    time.Time `json:"expiresAt"`
	User         UserInfo  `json:"user"`
}

// UserInfo represents basic user information returned after authentication
type UserInfo struct {
	ID        uuid.UUID `json:"id"`
	Email     string    `json:"email"`
	FirstName string    `json:"firstName"`
	LastName  string    `json:"lastName"`
	Role      string    `json:"role"`
}

// SSOProvider represents supported SSO providers
type SSOProvider string

const (
	Google   SSOProvider = "google"
	Facebook SSOProvider = "facebook"
	GitHub   SSOProvider = "github"
)

// SSORequest represents the SSO authentication request
type SSORequest struct {
	Provider SSOProvider `json:"provider"`
	Token    string      `json:"token"`
	Code     string      `json:"code,omitempty"`
	State    string      `json:"state,omitempty"`
}

// AuthSession represents an active authentication session
type AuthSession struct {
	ID           uuid.UUID   `json:"id"`
	UserID       uuid.UUID   `json:"userId"`
	Token        string      `json:"token"`
	RefreshToken string      `json:"refreshToken"`
	Provider     SSOProvider `json:"provider,omitempty"`
	ExpiresAt    time.Time   `json:"expiresAt"`
	CreatedAt    time.Time   `json:"createdAt"`
	LastUsedAt   time.Time   `json:"lastUsedAt"`
	UserAgent    string      `json:"userAgent"`
	IPAddress    string      `json:"ipAddress"`
}

// TokenClaims represents the JWT token claims
type TokenClaims struct {
	UserID    uuid.UUID   `json:"userId"`
	Email     string      `json:"email"`
	Role      string      `json:"role"`
	Provider  SSOProvider `json:"provider,omitempty"`
	SessionID uuid.UUID   `json:"sessionId"`
}
