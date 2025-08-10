package util

import (
	"log"
	"os"
)

func GetBinDir() string {
	// exePath, err := os.Executable()
	// if err != nil {
	// 	panic(err)
	// }
	exePath := os.Getenv("XDG_CONFIG_HOME")
	log.Printf("exePath: %s", exePath)
	return exePath
}
