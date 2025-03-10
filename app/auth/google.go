package auth

import (
	"context"
	"encoding/gob"
	"encoding/json"
	"net/http"

	"github.com/CHINMAYVIVEK/liveClass/configs"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

type OAuth struct {
	config *oauth2.Config
}

// Google OAuth user details struct
type GoAuth struct {
	Id            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Picture       string `json:"picture"`
	Locale        string `json:"locale"`
}

func init() {
	gob.Register(UserInfo{})
}

// Update InitGoogleOAuth to accept config as parameter
func InitGoogleOAuth(cfg *configs.Config) *OAuth {
	auth := &oauth2.Config{
		ClientID:     cfg.OAuthConfig.Google.ClientID,
		ClientSecret: cfg.OAuthConfig.Google.ClientSecret,
		RedirectURL:  cfg.OAuthConfig.Google.RedirectURL,
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
			"openid",
		},
		Endpoint: google.Endpoint,
	}
	return &OAuth{
		config: auth,
	}
}

func (a *OAuth) OAuthHandler(w http.ResponseWriter, r *http.Request) {
	url := a.config.AuthCodeURL("state", oauth2.AccessTypeOffline)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func (a *OAuth) OAuthCallbackHandler(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	t, err := a.config.Exchange(context.Background(), code)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	client := a.config.Client(context.Background(), t)
	resp, err := client.Get("https://www.googleapis.com/oauth2/v2/userinfo")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		http.Error(w, "Failed to get user info", http.StatusInternalServerError)
		return
	}
	var jsonResp GoAuth
	if err := json.NewDecoder(resp.Body).Decode(&jsonResp); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	// user := UserInfo{
	// 	ID:        jsonResp.Id,
	// 	Email:     jsonResp.Email,
	// 	FirstName: jsonResp.GivenName,
	// 	LastName:  jsonResp.FamilyName,
	// 	Picture:   jsonResp.Picture,
	// 	Locale:    jsonResp.Locale,
	// }

	// Store user data in session

	http.Redirect(w, r, "/student/dashboard", http.StatusTemporaryRedirect)
}
