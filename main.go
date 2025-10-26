package main

import (
	"context"
	"log"
	"time"

	"github.com/CHINMAYVIVEK/liveClass/configs"
	"github.com/CHINMAYVIVEK/liveClass/helper"
	"github.com/CHINMAYVIVEK/liveClass/internal/server"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

// Initialize logger

func init() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}

func main() {
	logger := helper.GetLogger()

	// Load .env file from root directory
	if err := godotenv.Load(); err != nil {
		logger.Warn("No .env file found — using environment variables from Vault")
	}

	// Create context with cancellation
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	// Load configurations
	cfg, err := configs.New(ctx)
	if err != nil {
		logger.Error("Failed to load configuration: ", err)
	}

	// Create and start the server
	srv := server.NewServer(cfg)

	// Start the server
	logger.Info("Server starting...")
	if err := srv.Start(); err != nil {
		logger.Error("Server failed to start: ", err)
	}
}
