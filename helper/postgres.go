package helper

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/CHINMAYVIVEK/liveClass/configs"
)

type PostgresWrapper struct {
	postgres *configs.PostgresDB
}

type Tx interface {
	QueryRow(ctx context.Context, query string, args ...interface{}) *sql.Row
	Exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
	Commit() error
	Rollback() error
}

type txWrapper struct {
	*sql.Tx
}

func NewPostgresWrapper(postgres *configs.PostgresDB) *PostgresWrapper {
	return &PostgresWrapper{postgres: postgres}
}

func (w *PostgresWrapper) getDB() (*sql.DB, error) {
	return w.postgres.GetDB()
}

func (w *PostgresWrapper) withTimeout(ctx context.Context) (context.Context, context.CancelFunc) {
	return context.WithTimeout(ctx, 10*time.Second)
}

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

func (t *txWrapper) QueryRow(ctx context.Context, query string, args ...interface{}) *sql.Row {
	return t.Tx.QueryRowContext(ctx, query, args...)
}

func (t *txWrapper) Exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error) {
	return t.Tx.ExecContext(ctx, query, args...)
}

func (w *PostgresWrapper) QueryRow(ctx context.Context, query string, args ...interface{}) (*sql.Row, error) {

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}
	return db.QueryRowContext(ctx, query, args...), nil
}

func (w *PostgresWrapper) Query(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error) {

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}
	return db.QueryContext(ctx, query, args...)
}

func (w *PostgresWrapper) exec(ctx context.Context, query string, args ...interface{}) (sql.Result, error) {

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}
	return db.ExecContext(ctx, query, args...)
}

func (w *PostgresWrapper) execAffected(ctx context.Context, query string, args ...interface{}) (int64, error) {
	result, err := w.exec(ctx, query, args...)
	if err != nil {
		return 0, err
	}
	return result.RowsAffected()
}

// UpsertReturning performs an upsert and returns a row for scanning
func (w *PostgresWrapper) UpsertReturning(ctx context.Context, query string, args ...interface{}) (*sql.Row, error) {
	ctx, cancel := w.withTimeout(ctx)
	defer cancel()

	db, err := w.getDB()
	if err != nil {
		return nil, err
	}
	return db.QueryRowContext(ctx, query, args...), nil
}

// Consolidated operations using execAffected
// Remove Insert and Update methods, keep only these core operations:

func (w *PostgresWrapper) Delete(ctx context.Context, query string, args ...interface{}) (int64, error) {
	return w.execAffected(ctx, query, args...)
}

func (w *PostgresWrapper) Upsert(ctx context.Context, query string, args ...interface{}) (int64, error) {
	return w.execAffected(ctx, query, args...)
}
