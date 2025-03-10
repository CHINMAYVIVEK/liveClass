package main

import (
	"context"
	"flag"
	"fmt"
	"liveClass/internal/database"
	"log"
	"os"
	"time"
)

func main() {
	// Define command line flags
	var (
		migrationsPath = flag.String("path", "./migrations", "Path to migration files")
		dbURL          = flag.String("db-url", "", "Database connection URL")
		dbName         = flag.String("db-name", "liveclass", "Database name")
		command        = flag.String("command", "up", "Migration command (up, down, status, goto)")
		version        = flag.Uint("version", 0, "Migration version for goto command")
	)

	flag.Parse()

	// Validate required flags
	if *dbURL == "" {
		log.Fatal("Database URL is required")
	}

	// Create migration config
	config := database.MigrationConfig{
		MigrationsPath: *migrationsPath,
		DatabaseURL:    *dbURL,
		DatabaseName:   *dbName,
	}

	// Create context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 1*time.Minute)
	defer cancel()

	// Execute command
	switch *command {
	case "up":
		if err := database.RunMigrations(ctx, config); err != nil {
			log.Fatalf("Failed to run migrations: %v", err)
		}
		fmt.Println("Migrations applied successfully")

	case "down":
		if err := database.MigrateDown(ctx, config); err != nil {
			log.Fatalf("Failed to roll back migration: %v", err)
		}
		fmt.Println("Migration rolled back successfully")

	case "status":
		version, dirty, err := database.MigrationStatus(ctx, config)
		if err != nil {
			log.Fatalf("Failed to get migration status: %v", err)
		}
		if version == 0 {
			fmt.Println("No migrations have been applied")
		} else {
			fmt.Printf("Current migration version: %d (dirty: %t)\n", version, dirty)
		}

	case "goto":
		if *version == 0 {
			log.Fatal("Version is required for goto command")
		}
		if err := database.MigrateTo(ctx, config, *version); err != nil {
			log.Fatalf("Failed to migrate to version %d: %v", *version, err)
		}
		fmt.Printf("Migration to version %d completed successfully\n", *version)

	default:
		fmt.Printf("Unknown command: %s\n", *command)
		os.Exit(1)
	}
}