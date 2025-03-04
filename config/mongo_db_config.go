package config

import (
	"context"
	"fmt"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// MongoDB represents a MongoDB connection manager
type MongoDB struct {
	config *MongoDBConfig
	client *mongo.Client
}

// MongoDBConfig holds MongoDB configuration
type MongoDBConfig struct {
	Host               string        `env:"MONGO_HOST" default:"localhost"`
	Port               string        `env:"MONGO_PORT" default:"27017"`
	User               string        `env:"MONGO_USER" default:""`
	Password           string        `env:"MONGO_PASSWORD" default:""`
	Database           string        `env:"MONGO_DB" default:"liveclass"`
	SetMaxPoolSize     uint64        `env:"MONGO_MAX_POOL_SIZE" default:"100"`
	SetMinPoolSize     uint64        `env:"MONGO_MIN_POOL_SIZE" default:"10"`
	SetMaxConnIdleTime time.Duration `env:"MONGO_CONN_IDLE_TIME" default:"5m"`
}

// NewMongoDB creates a new MongoDB instance
func NewMongoDB(config *MongoDBConfig) *MongoDB {
	return &MongoDB{
		config: config,
	}
}

// Connect establishes a connection to MongoDB with retry mechanism
func (m *MongoDB) Connect(ctx context.Context) error {
	uri := m.buildConnectionURI()

	clientOptions := options.Client().
		ApplyURI(uri).
		SetMaxPoolSize(m.config.SetMaxPoolSize).
		SetMinPoolSize(m.config.SetMinPoolSize).
		SetMaxConnIdleTime(m.config.SetMaxConnIdleTime * time.Minute)

	if err := m.attemptConnection(ctx, clientOptions); err != nil {
		return err
	}

	return nil
}

// buildConnectionURI constructs the MongoDB connection URI
func (m *MongoDB) buildConnectionURI() string {
	if m.config.User != "" && m.config.Password != "" {
		return fmt.Sprintf("mongodb://%s:%s@%s:%s/%s",
			m.config.User,
			m.config.Password,
			m.config.Host,
			m.config.Port,
			m.config.Database)
	}
	return fmt.Sprintf("mongodb://%s:%s/%s",
		m.config.Host,
		m.config.Port,
		m.config.Database)
}

// attemptConnection tries to establish a connection with retries
func (m *MongoDB) attemptConnection(ctx context.Context, clientOptions *options.ClientOptions) error {
	const (
		maxRetries = 3
		retryDelay = 2 * time.Second
	)

	var err error
	for i := 0; i < maxRetries; i++ {
		select {
		case <-ctx.Done():
			return fmt.Errorf("context cancelled while connecting to MongoDB: %w", ctx.Err())
		default:
			if m.client, err = mongo.Connect(ctx, clientOptions); err != nil {
				if i < maxRetries-1 {
					time.Sleep(retryDelay)
					continue
				}
				return fmt.Errorf("failed to connect to MongoDB after %d retries: %w", maxRetries, err)
			}

			// Ping to verify connection
			if err = m.client.Ping(ctx, nil); err != nil {
				if i < maxRetries-1 {
					time.Sleep(retryDelay)
					continue
				}
				return fmt.Errorf("failed to ping MongoDB after %d retries: %w", maxRetries, err)
			}

			return nil
		}
	}
	return nil
}

// GetClient returns the MongoDB client instance
func (m *MongoDB) GetClient() (*mongo.Client, error) {
	if m.client == nil {
		return nil, fmt.Errorf("MongoDB client not initialized")
	}
	return m.client, nil
}

// Close safely closes the MongoDB connection
func (m *MongoDB) Close(ctx context.Context) error {
	if m.client != nil {
		if err := m.client.Disconnect(ctx); err != nil {
			return fmt.Errorf("failed to disconnect MongoDB: %w", err)
		}
		m.client = nil
	}
	return nil
}
