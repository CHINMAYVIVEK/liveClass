package helper

import (
	"crypto/rand"
	"math/big"
	"regexp"
)

const (
	patternTypeMobile = "Mobile"
	patternTypeEmail  = "Email"

	emailPattern  = `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
	mobilePattern = `^\+\d{1,3}\d{10}$`

	passwordLength = 12
	passwordChars  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+,.?/:;{}[]~"
)

var (
	patterns = map[string]*regexp.Regexp{
		patternTypeMobile: regexp.MustCompile(mobilePattern),
		patternTypeEmail:  regexp.MustCompile(emailPattern),
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
