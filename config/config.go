package config

import (
	"context"
	"fmt"

	"github.com/caarlos0/env/v11"
)

type Config struct {
	App      *AppConfig
	Postgres *PostgresDB
}

func New(ctx context.Context) (*Config, error) {

	// Initialize configurations
	postgresConfig := &PSQLConfig{}
	appConfig := &AppConfig{}

	opts := env.Options{RequiredIfNoDef: true}
	if err := env.ParseWithOptions(appConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing App config: %v", err)
	}

	if err := env.ParseWithOptions(postgresConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing PostgreSQL config: %v", err)
	}

	postgres := NewPostgresDB(postgresConfig)

	if err := postgres.Connect(ctx); err != nil {
		// Close MongoDB connection if PostgreSQL connection fails
		// mongo.Close(ctx)
		return nil, fmt.Errorf("error connecting to PostgreSQL: %v", err)
	}

	cfg := &Config{
		App:      appConfig,
		Postgres: postgres,
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
