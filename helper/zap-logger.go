package helper

import (
	"os"
	"path/filepath"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	lumberjack "gopkg.in/natefinch/lumberjack.v2"
)

// Logger wraps zap logger functionality
type Logger struct {
	logger *zap.Logger
	sugar  *zap.SugaredLogger
}

var defaultLogger *Logger

// InitLogger initializes the logger with configuration
func InitLogger() (*Logger, error) {
	// Ensure logs directory exists
	logDir := "logs"
	if err := os.MkdirAll(logDir, 0755); err != nil {
		return nil, err
	}

	lumberjackLogrotate := &lumberjack.Logger{
		Filename:   filepath.Join(logDir, "access.log"),
		MaxSize:    1,   // Max megabytes before log is rotated
		MaxBackups: 90,  // Max number of old log files to keep
		MaxAge:     180, // Max number of days to retain log files
		Compress:   true,
	}

	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder

	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderConfig),
		zapcore.NewMultiWriteSyncer(
			zapcore.AddSync(os.Stdout),
			zapcore.AddSync(lumberjackLogrotate),
		),
		zap.NewAtomicLevelAt(zapcore.InfoLevel),
	)

	logger := zap.New(core, zap.AddCaller(), zap.AddCallerSkip(1))

	return &Logger{
		logger: logger,
		sugar:  logger.Sugar(),
	}, nil
}

// GetLogger returns the default logger instance
func GetLogger() *Logger {
	if defaultLogger == nil {
		var err error
		defaultLogger, err = InitLogger()
		if err != nil {
			panic(err)
		}
	}
	return defaultLogger
}

// Debug logs a debug message
func (l *Logger) Debug(args ...interface{}) {
	l.sugar.Debug(args...)
}

// Info logs an info message
func (l *Logger) Info(args ...interface{}) {
	l.sugar.Info(args...)
}

// Warn logs a warning message
func (l *Logger) Warn(args ...interface{}) {
	l.sugar.Warn(args...)
}

// Error logs an error message
func (l *Logger) Error(args ...interface{}) {
	l.sugar.Error(args...)
}

// Debugf logs a formatted debug message
func (l *Logger) Debugf(format string, args ...interface{}) {
	l.sugar.Debugf(format, args...)
}

// Infof logs a formatted info message
func (l *Logger) Infof(format string, args ...interface{}) {
	l.sugar.Infof(format, args...)
}

// Warnf logs a formatted warning message
func (l *Logger) Warnf(format string, args ...interface{}) {
	l.sugar.Warnf(format, args...)
}

// Errorf logs a formatted error message
func (l *Logger) Errorf(format string, args ...interface{}) {
	l.sugar.Errorf(format, args...)
}

// Sync flushes any buffered log entries
func (l *Logger) Sync() error {
	return l.logger.Sync()
}
