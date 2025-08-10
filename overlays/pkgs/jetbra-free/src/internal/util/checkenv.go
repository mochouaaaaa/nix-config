package util

import (
	"fmt"
	"os"
	"strings"
	"unicode"
)

type CheckEnv struct {
	Variables   map[string]string
	HasVars     bool
	EnglishPath bool
	Path        string
}

func GetVMOptionsVars() CheckEnv {
	vars := make(map[string]string)
	for _, env := range os.Environ() {
		parts := strings.SplitN(env, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key, value := parts[0], parts[1]
		if strings.HasSuffix(key, "_VM_OPTIONS") {
			vars[key] = value
		}
	}

	return CheckEnv{
		Variables:   vars,
		HasVars:     len(vars) > 0,
		EnglishPath: IsPureEnglishPath(GetBinDir()),
		Path:        GetBinDir(),
	}
}

// Determine whether the path is a pure English path (including only ASCII letters, numbers, and commonly used symbols)
func IsPureEnglishPath(path string) bool {
	for _, r := range path {
		if r > unicode.MaxASCII || !(unicode.IsLetter(r) || unicode.IsDigit(r) ||
			r == '_' || r == '-' || r == '.' || r == '/' || r == '\\' || r == ':') {
			fmt.Println("Non-English character found in path:", path)
			return false
		}
	}
	return true
}
