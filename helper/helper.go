package helper

import (
	"bytes"
	"database/sql"
	"encoding/json"
)

func JSONMarshal(v map[string]string, safeEncoding bool) ([]byte, error) {
	b, err := json.Marshal(v)

	if safeEncoding {
		b = bytes.Replace(b, []byte("\\u003c"), []byte("<"), -1)
		b = bytes.Replace(b, []byte("\\u003e"), []byte(">"), -1)
		b = bytes.Replace(b, []byte("\\u0026"), []byte("&"), -1)
	}
	return b, err
}

func Contains(s []int, e int) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func CheckString(statuscreatedat sql.NullString) string {
	statuscreatedat_ := ""
	if statuscreatedat.Valid {
		statuscreatedat_ = statuscreatedat.String
	}
	return statuscreatedat_
}
