package helper

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"regexp"
	"strings"
)

const (
	PatternTypeMobile = "Mobile"
	PatternTypeEmail  = "Email"

	emailPattern  = `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
	mobilePattern = `^\+\d{1,3}\d{10}$`

	passwordLength = 12
	passwordChars  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+,.?/:;{}[]~"
)

var (
	ErrDuplicateEmail      = fmt.Errorf("email already exists")
	ErrStudentRoleNotFound = fmt.Errorf("student role not found")
	ErrInvalidInput        = fmt.Errorf("invalid input")
)

var (
	patterns = map[string]*regexp.Regexp{
		PatternTypeMobile: regexp.MustCompile(mobilePattern),
		PatternTypeEmail:  regexp.MustCompile(emailPattern),
	}
)

func PatternValidation(patternType, value string) bool {
	if pattern, ok := patterns[patternType]; ok {
		return pattern.MatchString(value)
	}
	return false
}

func IsPasswordStrong(password string) bool {
	if len(password) < 8 {
		return false
	}

	// Bitwise flags to track the presence of uppercase letters, lowercase letters, digits, and special characters.
	hasUpperCase := false
	hasLowerCase := false
	hasDigit := false
	hasSpecialChar := false

	for _, char := range password {
		switch {
		case 'A' <= char && char <= 'Z':
			hasUpperCase = true
		case 'a' <= char && char <= 'z':
			hasLowerCase = true
		case '0' <= char && char <= '9':
			hasDigit = true
		default:
			hasSpecialChar = true
		}

		// If all the flags are set, we can break the loop early.
		if hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar {
			break
		}
	}

	return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar
}

func GenerateRandomPassword() string {
	password := make([]byte, passwordLength)
	for i := 0; i < passwordLength; i++ {
		index, _ := rand.Int(rand.Reader, big.NewInt(int64(len(passwordChars))))
		password[i] = passwordChars[index.Int64()]
	}
	return string(password)
}

func IsValidGender(gender string) bool {
	validGenders := map[string]bool{
		"male":        true,
		"female":      true,
		"transgender": true,
	}
	return validGenders[gender]
}

func IsPgUniqueViolation(err error) bool {
	// Implement PostgreSQL unique violation error check
	// This will depend on your PostgreSQL driver
	return strings.Contains(err.Error(), "unique constraint") ||
		strings.Contains(err.Error(), "duplicate key")
}
