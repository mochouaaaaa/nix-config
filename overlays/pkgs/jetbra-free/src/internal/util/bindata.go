package util

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func ExtractAssets(outputDir string) error {
	for _, name := range AssetNames() {
		destPath := filepath.Join(outputDir, name)

		log.Printf("Extracting %s to %s", name, destPath)
		if strings.Contains(name, "/ja-netfilter/") {
			if _, err := os.Stat(destPath); err == nil {
				continue
			}
		}

		err := os.MkdirAll(filepath.Dir(destPath), os.ModePerm)
		if err != nil {
			return err
		}

		data, err := Asset(name)
		if err != nil {
			return err
		}

		err = os.WriteFile(destPath, data, os.ModePerm)
		if err != nil {
			fmt.Printf("Write to the file failed, please close the ide and try again: %s:warning: %v\n", destPath, err)
			continue
		}
	}
	return nil
}
