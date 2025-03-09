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

	templateBase = "template"
	lmsPanel     = templateBase + "/lms_panel"
)

type templateFiles struct {
	base, header, sidebar, footer, content string
}

var (
	defaultFiles = templateFiles{
		base:    "/base.html",
		header:  "/_header.html",
		footer:  "/_footer.html",
		sidebar: "/_sidebar.html",
		content: "/%s.html",
	}

	templatePaths = map[ViewType]string{
		StudentView:    lmsPanel + "/student",
		InstructorView: lmsPanel + "/instructor",
		WebsiteView:    templateBase + "/website",
	}

	templateStore = &TemplateCache{
		cache: make(map[string]*template.Template),
	}

	defaultFuncMap = template.FuncMap{
		"marshal": func(v interface{}) template.JS {
			if b, err := json.Marshal(v); err == nil {
				return template.JS(b)
			}
			return template.JS("{}")
		},
	}
)

type TemplateCache struct {
	cache map[string]*template.Template
	mu    sync.RWMutex
}

func buildPaths(base string, view ViewType, name string) []string {
	paths := []string{
		base + defaultFiles.base,
		base + defaultFiles.header,
		base + defaultFiles.footer,
		base + fmt.Sprintf(defaultFiles.content, name),
	}
	if view != WebsiteView {
		paths = append(paths, base+defaultFiles.sidebar)
	}
	return paths
}

func LoadTemplate(view ViewType, name string) (*template.Template, error) {
	if name == "" {
		return nil, fmt.Errorf("template name cannot be empty")
	}

	cacheKey := string(view) + ":" + name
	if tmpl, exists := templateStore.get(cacheKey); exists {
		return tmpl, nil
	}

	basePath, ok := templatePaths[view]
	if !ok {
		return nil, fmt.Errorf("invalid view type: %s", view)
	}

	allFiles := buildPaths(basePath, view, name)
	tmpl := template.New(name).Funcs(defaultFuncMap)
	parsedTmpl, err := tmpl.ParseFiles(allFiles...)
	if err != nil {
		return nil, fmt.Errorf("failed to parse template files: %w", err)
	}

	templateStore.set(cacheKey, parsedTmpl)
	return parsedTmpl, nil
}

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

func (tc *TemplateCache) Clear() {
	tc.mu.Lock()
	defer tc.mu.Unlock()
	tc.cache = make(map[string]*template.Template)
}
