package util

import (
	"os"
	"path/filepath"
)

func GetBinDir() string {
	// exePath, err := os.Executable()
	// if err != nil {
	// 	panic(err)
	// }
	exePath := os.Getenv("XDG_CONFIG_HOME")
	return filepath.Dir(exePath)
}
