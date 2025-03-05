package helper

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"liveClass/config"
)

type PostgresWrapper struct {
	postgres *config.PostgresDB
}

type Tx interface {
	QueryRow(ctx context.Context, query string, args ...interface{}) *sql.Row
	Exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
	Commit() error
	Rollback() error
}

func NewPostgresWrapper(postgres *config.PostgresDB) *PostgresWrapper {
	return &PostgresWrapper{
		postgres: postgres,
	}
}

// Add this type to wrap sql.Tx
type txWrapper struct {
	*sql.Tx
}

// Implement the Tx interface methods for txWrapper
func (t *txWrapper) QueryRow(ctx context.Context, query string, args ...interface{}) *sql.Row {
	return t.Tx.QueryRowContext(ctx, query, args...)
}

func (t *txWrapper) Exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error) {
	return t.Tx.ExecContext(ctx, query, args...)
}

// Update BeginTx to use the wrapper
func (w *PostgresWrapper) BeginTx(ctx context.Context) (Tx, error) {
	db, err := w.getDB()
	if err != nil {
		return nil, err
	}
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to begin transaction: %w", err)
	}
	return &txWrapper{tx}, nil
}
func (w *PostgresWrapper) getDB() (*sql.DB, error) {
	return w.postgres.GetDB()
}

func (w *PostgresWrapper) QueryRow(ctx context.Context, query string, args ...interface{}) (*sql.Row, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}

	return db.QueryRowContext(ctx, query, args...), nil
}

func (w *PostgresWrapper) Query(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}

	rows, err := db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to execute query: %w", err)
	}
	return rows, nil
}

func (w *PostgresWrapper) Exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}

	result, err := db.ExecContext(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to execute statement: %w", err)
	}
	return result, nil
}

// InsertReturning returns a Row that can be scanned for returning values
func (w *PostgresWrapper) InsertReturning(ctx context.Context, query string, args ...interface{}) *sql.Row {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	db, err := w.getDB()
	if err != nil {
		return nil
	}

	return db.QueryRowContext(ctx, query, args...)
}

// Update the existing Insert method to use the new InsertReturning
func (w *PostgresWrapper) Insert(ctx context.Context, query string, args ...interface{}) (int64, error) {
	var id int64
	err := w.InsertReturning(ctx, query, args...).Scan(&id)
	if err != nil {
		return 0, fmt.Errorf("failed to insert record: %w", err)
	}
	return id, nil
}

func (w *PostgresWrapper) Update(ctx context.Context, query string, args ...interface{}) (int64, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	result, err := w.Exec(ctx, query, args...)
	if err != nil {
		return 0, err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return 0, fmt.Errorf("failed to get affected rows: %w", err)
	}
	return rowsAffected, nil
}

func (w *PostgresWrapper) Delete(ctx context.Context, query string, args ...interface{}) (int64, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	result, err := w.Exec(ctx, query, args...)
	if err != nil {
		return 0, err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return 0, fmt.Errorf("failed to get affected rows: %w", err)
	}
	return rowsAffected, nil
}
