package logging

import (
	"log"
	"os"

	"github.com/sykesm/zap-logfmt"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func InitializeZapLogfmt(logDir *string) *zap.Logger {
	config := zap.NewProductionEncoderConfig()
	config.EncodeTime = zapcore.ISO8601TimeEncoder

	if *logDir != "" {
		if fi, err := os.Lstat(*logDir); err != nil || !fi.IsDir() {
			log.Fatalf("%s is not a directory", *logDir)
		}
		// We could do fdup acrobatics to also redirect
		// stderr, but it is simpler and more portable for the
		// caller to divert stderr output if necessary.
	}

	logger := zap.New(zapcore.NewCore(
		zaplogfmt.NewEncoder(config),
		os.Stderr,
		zapcore.DebugLevel,
	))
	defer logger.Sync()
	return logger
}
