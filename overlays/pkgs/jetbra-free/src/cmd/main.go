package main

import (
	"fmt"
	"jetbra-free/internal/certificate"
	"jetbra-free/internal/core"
	"jetbra-free/internal/util"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"time"

	"github.com/gin-gonic/gin"
)

func cors() gin.HandlerFunc {
	return func(c *gin.Context) {
		method := c.Request.Method
		origin := c.Request.Header.Get("Origin")

		if origin != "" {
			c.Header("Access-Control-Allow-Origin", "*")
			c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, UPDATE")
			c.Header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization")
			c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type")
			c.Header("Access-Control-Allow-Credentials", "true")
		}
		if method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
		}
		c.Next()
	}
}

func init() {
	binPath := os.Getenv("XDG_CONFIG_HOME")
	log.Printf("XDG_CONFIG_HOME: %s == ", binPath)
	resourceDir := filepath.Join(binPath, ".jetbra-free")

	var err error
	err = os.MkdirAll(resourceDir, 0755)
	if err != nil {
		log.Fatalf("Failed to create resource directory: %v", err)
	}

	err = util.ExtractAssets(resourceDir)
	if err != nil {
		panic(fmt.Sprintf("Failed to extract assets: %v", err))
	}
	core.PluginsInit()
	certificate.Run()
	core.LicenseInit()
}

func main() {
	fmt.Println("     _      _   _                 _____              ")
	fmt.Println("    | | ___| |_| |__  _ __ __ _  |  ___| __ ___  ___ ")
	fmt.Println(" _  | |/ _ \\ __| '_ \\| '__/ _` | | |_ | '__/ _ \\/ _ \\")
	fmt.Println("| |_| |  __/ |_| |_) | | | (_| | |  _|| | |  __/  __/")
	fmt.Println(" \\___/ \\___|\\__|_.__/|_|  \\__,_| |_|  |_|  \\___|\\___|")
	address := "127.0.0.1:8123"
	log.Printf("Server running at: http://%s\n", address)
	gin.SetMode(gin.ReleaseMode)
	// init route
	r := gin.Default()
	r.Use(cors())

	binDir := os.Getenv("XDG_CONFIG_HOME")
	r.Static("/static", filepath.Join(binDir, ".jetbra-free", "static"))

	r.LoadHTMLGlob(filepath.Join(binDir, ".jetbra-free", "templates/*"))

	r.GET("/favicon.ico", func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "https://www.jetbrains.com/favicon.ico")
	})
	r.GET("/", core.Index)
	r.POST("/generateLicense", core.GenerateLicenseHandler)
	r.POST("/crack", core.CrackHandler)

	go func() {
		time.Sleep(500 * time.Millisecond)
		url := fmt.Sprintf("http://%s", address)
		err := openBrowser(url)
		if err != nil {
			fmt.Println("Please open the browser manually:", err)
		}
	}()

	r.Run(address)
}

func openBrowser(url string) error {
	switch runtime.GOOS {
	case "linux":
		return exec.Command("xdg-open", url).Start()
	case "windows":
		return exec.Command("rundll32", "url.dll,FileProtocolHandler", url).Start()
	case "darwin":
		return exec.Command("open", url).Start()
	default:
		return nil
	}
}
