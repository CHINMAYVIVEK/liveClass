package helper

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"html/template"
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

func LoadTemplate(isPanel bool, name string, files ...string) (*template.Template, error) {
	// Add layout.html to all templates

	if isPanel {
		files = append([]string{
			"template/lms_panel/base.html",
			"template/lms_panel/header.html",
			"template/lms_panel/sidebar.html",
		}, files...)
	} else {
		files = append([]string{
			"template/website/layout.html",
			"template/website/_header.html",
			"template/website/_footer.html",
		}, files...)
	}

	funcMap := template.FuncMap{
		"marshal": func(v interface{}) template.JS {
			a, _ := json.Marshal(v)
			return template.JS(a)
		},
	}

	return template.New(name).Funcs(funcMap).ParseFiles(files...)
}
