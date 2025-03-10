package helper

import (
	"net/http"

	"github.com/alexedwards/scs/v2"
)

func SessionManager() *scs.SessionManager {
	manager := scs.New()
	manager.Lifetime = 24 * 60 * 60
	manager.Cookie.Persist = true
	manager.Cookie.SameSite = http.SameSiteLaxMode
	manager.Cookie.Secure = true
	return manager
}
