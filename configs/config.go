package configs

import (
	"context"
	"fmt"

	"github.com/caarlos0/env/v11"
)

type Config struct {
	App         *AppConfig
	Postgres    *PostgresDB
	OAuthConfig *OAuthConfig
}

func New(ctx context.Context) (*Config, error) {

	// Initialize configurations
	postgresConfig := &PSQLConfig{}
	appConfig := &AppConfig{}
	googleOAuthConfig := &GoogleOAuthConfig{}

	opts := env.Options{RequiredIfNoDef: true}
	if err := env.ParseWithOptions(appConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing App config: %v", err)
	}
	if err := env.ParseWithOptions(googleOAuthConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing OAuth config: %v", err)
	}

	if err := env.ParseWithOptions(postgresConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing PostgreSQL config: %v", err)
	}
	postgres := NewPostgresDB(postgresConfig)
	if err := postgres.Connect(ctx); err != nil {
		return nil, fmt.Errorf("error connecting to PostgreSQL: %v", err)
	}

	cfg := &Config{
		App:      appConfig,
		Postgres: postgres,
		OAuthConfig: &OAuthConfig{
			Google: *googleOAuthConfig,
		},
	}

	return cfg, nil
}

// Close safely closes all database connections
func (c *Config) Close(ctx context.Context) error {

	defer func() {
		if err := c.Postgres.Close(); err != nil {
			fmt.Printf("error closing PostgreSQL connection: %v\n", err)
		}
	}()

	return nil
}
