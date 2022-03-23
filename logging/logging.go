package logging

import (
	"os"

	"github.com/sykesm/zap-logfmt"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func InitializeZapLogfmt() *zap.Logger {
	config := zap.NewProductionEncoderConfig()
	logger := zap.New(zapcore.NewCore(
		zaplogfmt.NewEncoder(config),
		os.Stdout,
		zapcore.DebugLevel,
	))
	return logger
}
