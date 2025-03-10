package configs

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	_ "github.com/lib/pq"
)

// PostgresDB represents a PostgreSQL database connection manager
type PostgresDB struct {
	config *PSQLConfig
	db     *sql.DB
}

// PSQLConfig holds PostgreSQL database configuration
type PSQLConfig struct {
	Host               string        `env:"POSTGRES_HOST" default:"localhost"`
	Port               string        `env:"POSTGRES_PORT" default:"5432"`
	User               string        `env:"POSTGRES_USER" default:"postgres"`
	Password           string        `env:"POSTGRES_PASSWORD" default:"postgres"`
	DBName             string        `env:"POSTGRES_DB_NAME" default:"liveclass"`
	SetMaxOpenConns    int           `env:"POSTGRES_MAX_OPEN_CONNS" default:"25"`
	SetMaxIdleConns    int           `env:"POSTGRES_MAX_IDLE_CONNS" default:"5"`
	SetConnMaxLifetime time.Duration `env:"POSTGRES_CONN_MAX_LIFETIME" default:"5m"`
}

// NewPostgresDB creates a new PostgresDB instance
func NewPostgresDB(config *PSQLConfig) *PostgresDB {
	return &PostgresDB{
		config: config,
	}
}

// Connect establishes a connection to PostgreSQL with retry mechanism
func (p *PostgresDB) Connect(ctx context.Context) error {

	dbInfo := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		p.config.Host, p.config.Port, p.config.User, p.config.Password, p.config.DBName)

	db, err := sql.Open("postgres", dbInfo)
	if err != nil {
		return fmt.Errorf("failed to open database connection: %w", err)
	}

	// Configure connection pool
	db.SetMaxOpenConns(p.config.SetMaxOpenConns)
	db.SetMaxIdleConns(p.config.SetMaxIdleConns)
	db.SetConnMaxLifetime(p.config.SetConnMaxLifetime * time.Minute)

	p.db = db
	return nil
}

// GetDB returns the database connection instance
func (p *PostgresDB) GetDB() (*sql.DB, error) {
	if p.db == nil {
		return nil, fmt.Errorf("database connection not initialized")
	}
	return p.db, nil
}

// Close safely closes the database connection
func (p *PostgresDB) Close() error {
	if p.db != nil {
		err := p.db.Close()
		p.db = nil
		return err
	}
	return nil
}
