package configs

import "time"

type AppConfig struct {
	LogLevel     string        `env:"LOG_LEVEL" default:"debug"`
	ServerPort   string        `env:"SERVER_PORT" default:":8080"`
	ReadTimeout  time.Duration `env:"READ_TIMEOUT" default:"15s"`
	WriteTimeout time.Duration `env:"WRITE_TIMEOUT" default:"15s"`
	IdleTimeout  time.Duration `env:"IDLE_TIMEOUT" default:"60s"`
}

type OAuthConfig struct {
	Google GoogleOAuthConfig
}

type GoogleOAuthConfig struct {
	ClientID       string `env:"GOOGLE_CLIENT_ID"`
	ClientSecret   string `env:"GOOGLE_CLIENT_SECRET"`
	RedirectURL    string `env:"GOOGLE_REDIRECT_URL"`
	MeetAPIURL     string `env:"GOOGLE_MEET_API_URL"`
	CalendarAPIURL string `env:"GOOGLE_CALENDAR_API_URL"` 
	YouTubeAPIURL  string `env:"YOUTUBE_API_URL"`
	YouTubeAPIKey  string `env:"YOUTUBE_API_KEY"`
}
