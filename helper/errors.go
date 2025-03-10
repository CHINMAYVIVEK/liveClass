package helper

import (
	"errors"
	"fmt"
	"net/http"
)

// Standard error types
var (
	ErrNotFound          = errors.New("resource not found")
	ErrUnauthorized      = errors.New("unauthorized")
	ErrForbidden         = errors.New("forbidden")
	ErrBadRequest        = errors.New("bad request")
	ErrInternalServer    = errors.New("internal server error")
	ErrDuplicateResource = errors.New("resource already exists")
	ErrValidation        = errors.New("validation error")
	ErrTimeout           = errors.New("operation timed out")
)

// AppError represents an application error
type AppError struct {
	Err        error
	StatusCode int
	Code       string
	Message    string
	Details    interface{}
}

// Error returns the error message
func (e *AppError) Error() string {
	return e.Message
}

// Unwrap returns the wrapped error
func (e *AppError) Unwrap() error {
	return e.Err
}

// New creates a new AppError
func New(err error, statusCode int, code, message string, details interface{}) *AppError {
	return &AppError{
		Err:        err,
		StatusCode: statusCode,
		Code:       code,
		Message:    message,
		Details:    details,
	}
}

// NotFound creates a new not found error
func NotFound(message string, details interface{}) *AppError {
	return New(ErrNotFound, http.StatusNotFound, "NOT_FOUND", message, details)
}

// Unauthorized creates a new unauthorized error
func Unauthorized(message string, details interface{}) *AppError {
	return New(ErrUnauthorized, http.StatusUnauthorized, "UNAUTHORIZED", message, details)
}

// Forbidden creates a new forbidden error
func Forbidden(message string, details interface{}) *AppError {
	return New(ErrForbidden, http.StatusForbidden, "FORBIDDEN", message, details)
}

// BadRequest creates a new bad request error
func BadRequest(message string, details interface{}) *AppError {
	return New(ErrBadRequest, http.StatusBadRequest, "BAD_REQUEST", message, details)
}

// InternalServer creates a new internal server error
func InternalServer(err error, details interface{}) *AppError {
	return New(ErrInternalServer, http.StatusInternalServerError, "INTERNAL_SERVER_ERROR",
		fmt.Sprintf("Internal server error: %v", err), details)
}

// DuplicateResource creates a new duplicate resource error
func DuplicateResource(message string, details interface{}) *AppError {
	return New(ErrDuplicateResource, http.StatusConflict, "DUPLICATE_RESOURCE", message, details)
}

// Validation creates a new validation error
func Validation(message string, details interface{}) *AppError {
	return New(ErrValidation, http.StatusBadRequest, "VALIDATION_ERROR", message, details)
}

// Is checks if the error is of the given type
func Is(err, target error) bool {
	return errors.Is(err, target)
}

// As finds the first error in err's chain that matches target
func As(err error, target interface{}) bool {
	return errors.As(err, target)
}
