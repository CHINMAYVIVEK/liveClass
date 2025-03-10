package auth

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

// GoogleUserInfo represents the user information returned by Google
type GoogleUserInfo struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	Name          string `json:"name"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Picture       string `json:"picture"`
	Locale        string `json:"locale"`
}

var (
	// GoogleOAuthConfig is the OAuth2 config for Google
	GoogleOAuthConfig *oauth2.Config
	// StateStore stores the OAuth state for CSRF protection
	StateStore = make(map[string]time.Time)
)

// InitGoogleOAuth initializes the Google OAuth configuration
func InitGoogleOAuth() {
	GoogleOAuthConfig = &oauth2.Config{
		ClientID:     GoogleOAuthConfig.ClientID,
		ClientSecret: GoogleOAuthConfig.ClientSecret,
		RedirectURL:  GoogleOAuthConfig.RedirectURL,
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
		},
		Endpoint: google.Endpoint,
	}
}

// GenerateStateToken creates a random state token for CSRF protection
func GenerateStateToken() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	state := base64.StdEncoding.EncodeToString(b)
	StateStore[state] = time.Now().Add(15 * time.Minute) // State valid for 15 minutes
	return state, nil
}

// ValidateState checks if the state token is valid
func ValidateState(state string) bool {
	expiry, exists := StateStore[state]
	if !exists {
		return false
	}
	if time.Now().After(expiry) {
		delete(StateStore, state)
		return false
	}
	delete(StateStore, state) // Use once only
	return true
}

// HandleGoogleLogin initiates the Google OAuth flow
func HandleGoogleLogin(w http.ResponseWriter, r *http.Request) {
	state, err := GenerateStateToken()
	if err != nil {
		http.Error(w, "Failed to generate state token", http.StatusInternalServerError)
		return
	}

	url := GoogleOAuthConfig.AuthCodeURL(state)
	fmt.Println("HandleGoogleLogin calle=====>> 3")
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

// HandleGoogleCallback handles the callback from Google OAuth
func HandleGoogleCallback(w http.ResponseWriter, r *http.Request) {
	state := r.FormValue("state")
	if !ValidateState(state) {
		http.Error(w, "Invalid state token", http.StatusBadRequest)
		return
	}

	code := r.FormValue("code")
	token, err := GoogleOAuthConfig.Exchange(context.Background(), code)
	if err != nil {
		http.Error(w, "Failed to exchange token: "+err.Error(), http.StatusInternalServerError)
		return
	}

	userInfo, err := GetGoogleUserInfo(token.AccessToken)
	if err != nil {
		http.Error(w, "Failed to get user info: "+err.Error(), http.StatusInternalServerError)
		return
	}

	fmt.Println("User Info:", userInfo)
	// Here you would typically:
	// 1. Check if the user exists in your database
	// 2. Create a new user if they don't exist
	// 3. Create a session for the user
	// 4. Redirect to the appropriate page

	// For now, we'll just redirect to the home page
	// You should implement proper user handling based on your application's needs

	// Create a session for the user (implement your session management here)
	// Example: session.Set(r, "user_id", userInfo.ID)

	http.Redirect(w, r, "/", http.StatusTemporaryRedirect)
}

// GetGoogleUserInfo retrieves the user's information from Google
func GetGoogleUserInfo(accessToken string) (*GoogleUserInfo, error) {
	resp, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var userInfo GoogleUserInfo
	if err := json.Unmarshal(body, &userInfo); err != nil {
		return nil, err
	}

	return &userInfo, nil
}
