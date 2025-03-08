package helper

import (
	"encoding/json"
	"fmt"
	"html/template"
	"sync"
)

type ViewType string

const (
	StudentView    ViewType = "student"
	InstructorView ViewType = "instructor"
	WebsiteView    ViewType = "website"
)

var templatePaths = map[ViewType][]string{
	StudentView: {
		"template/lms_panel/student/base.html",
		"template/lms_panel/student/_header.html",
		"template/lms_panel/student/_sidebar.html",
		"template/lms_panel/student/_footer.html",
	},
	InstructorView: {
		"template/lms_panel/instructor/base.html",
		"template/lms_panel/instructor/_header.html",
		"template/lms_panel/instructor/_sidebar.html",
		"template/lms_panel/instructor/_footer.html",
	},
	WebsiteView: {
		"template/website/base.html",
		"template/website/_header.html",
		"template/website/_footer.html",
	},
}

type TemplateCache struct {
	cache map[string]*template.Template
	mu    sync.RWMutex
}

var (
	defaultFuncMap = template.FuncMap{
		"marshal": func(v interface{}) template.JS {
			if b, err := json.Marshal(v); err == nil {
				return template.JS(b)
			}
			return template.JS("{}")
		},
	}

	templateStore = &TemplateCache{
		cache: make(map[string]*template.Template),
	}
)

func (tc *TemplateCache) get(key string) (*template.Template, bool) {
	tc.mu.RLock()
	defer tc.mu.RUnlock()
	tmpl, exists := tc.cache[key]
	return tmpl, exists
}

func (tc *TemplateCache) set(key string, tmpl *template.Template) {
	tc.mu.Lock()
	defer tc.mu.Unlock()
	tc.cache[key] = tmpl
}

func LoadTemplate(view ViewType, name string, files ...string) (*template.Template, error) {
	cacheKey := string(view) + ":" + name

	if tmpl, exists := templateStore.get(cacheKey); exists {
		return tmpl, nil
	}

	baseFiles, ok := templatePaths[view]
	if !ok {
		return nil, fmt.Errorf("invalid view type: %s", view)
	}

	allFiles := make([]string, 0, len(baseFiles)+len(files))
	allFiles = append(allFiles, baseFiles...)
	allFiles = append(allFiles, files...)

	tmpl := template.New(name).Funcs(defaultFuncMap)
	parsedTmpl, err := tmpl.ParseFiles(allFiles...)
	if err != nil {
		return nil, fmt.Errorf("failed to parse template files: %w", err)
	}

	templateStore.set(cacheKey, parsedTmpl)
	return parsedTmpl, nil
}
