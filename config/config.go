package config

import (
	"context"
	"fmt"
	"time"

	"github.com/caarlos0/env/v11"
)

type Config struct {
	App      *AppConfig
	Mongo    *MongoDB
	Postgres *PostgresDB
}

func New(ctx context.Context) (*Config, error) {

	// Initialize configurations
	// mongoConfig := &MongoDBConfig{}
	postgresConfig := &PSQLConfig{}
	appConfig := &AppConfig{}

	opts := env.Options{RequiredIfNoDef: true}
	if err := env.ParseWithOptions(appConfig, opts); err != nil {
		return nil, fmt.Errorf("error parsing App config: %v", err)
	}

	// if err := env.Parse(mongoConfig); err != nil {
	// 	return nil, fmt.Errorf("error parsing MongoDB config: %v", err)
	// }

	// // Initialize database connections
	// mongo := NewMongoDB(mongoConfig)
	// if err := mongo.Connect(ctx); err != nil {
	// 	return nil, fmt.Errorf("error connecting to MongoDB: %v", err)
	// }

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
		App: appConfig,
		// Mongo:    mongo,
		Postgres: postgres,
	}

	return cfg, nil
}

// Close safely closes all database connections
func (c *Config) Close(ctx context.Context) error {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	if err := c.Mongo.Close(ctx); err != nil {
		return fmt.Errorf("error closing MongoDB connection: %v", err)
	}

	if err := c.Postgres.Close(); err != nil {
		return fmt.Errorf("error closing PostgreSQL connection: %v", err)
	}

	return nil
}
