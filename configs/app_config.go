package configs

import "time"

type AppConfig struct {
	LogLevel     string        `env:"LOG_LEVEL" default:"debug"`
	ServerPort   string        `env:"SERVER_PORT" default:":8080"`
	ReadTimeout  time.Duration `env:"READ_TIMEOUT" default:"15s"`
	WriteTimeout time.Duration `env:"WRITE_TIMEOUT" default:"15s"`
	IdleTimeout  time.Duration `env:"IDLE_TIMEOUT" default:"60s"`
}
