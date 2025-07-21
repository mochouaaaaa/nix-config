package core

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"log"
	"math/big"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func LicenseInit() {
	log.Printf("Start LicenseInit...")
	// load private key and certificate
	privateKeyPEM, err := os.ReadFile(keyPath)
	if err != nil {
		panic("failed to read jetbra.key file, cause: " + err.Error())
	}

	block, _ := pem.Decode(privateKeyPEM)

	privateKey, err = x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		panic("parsing jetbra.key file failed, cause: " + err.Error())
	}

	crtPEM, err := os.ReadFile(certPath)
	if err != nil {
		panic("failed to read jetbra.pem file, cause: " + err.Error())
	}
	block, _ = pem.Decode(crtPEM)
	crt, err = x509.ParseCertificate(block.Bytes)
	if err != nil {
		panic("parsing jetbra.pem file failed, cause: " + err.Error())
	}
	log.Printf("LicenseInit Finished")
}

var (
	privateKey *rsa.PrivateKey
	crt        *x509.Certificate
)

type License struct {
	Products           []Product `json:"products"`
	LicenseID          string    `json:"licenseId"`
	LicenseeName       string    `json:"licenseeName"`
	AssigneeName       string    `json:"assigneeName"`
	AssigneeEmail      string    `json:"assigneeEmail"`
	LicenseRestriction string    `json:"licenseRestriction"`
	Metadata           string    `json:"metadata"`
	Hash               string    `json:"hash"`
	GracePeriodDays    int       `json:"gracePeriodDays"`
	CheckConcurrentUse bool      `json:"checkConcurrentUse"`
	AutoProlongated    bool      `json:"autoProlongated"`
	IsAutoProlongated  bool      `json:"isAutoProlongated"`
}

type Product struct {
	Code         string `json:"code"`
	FallbackDate string `json:"fallbackDate"`
	PaidUpTo     string `json:"paidUpTo"`
	Extended     bool   `json:"extended"`
}

func generateLicenseID() string {
	const allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	const licenseLength = 10
	b := make([]byte, licenseLength)
	for i := range b {
		index, _ := rand.Int(rand.Reader, big.NewInt(int64(len(allowedCharacters))))
		b[i] = allowedCharacters[index.Int64()]
	}
	return string(b)
}

func GenerateLicenseHandler(c *gin.Context) {
	var license License
	if err := c.ShouldBindJSON(&license); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	licenseStr, err := GenerateLicense(&license)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"license": licenseStr})
}

func GenerateLicense(license *License) (string, error) {
	license.LicenseID = generateLicenseID()
	licenseBytes, err := json.Marshal(license)
	if err != nil {
		return "", fmt.Errorf("failed to marshal license: %w", err)
	}

	if os.Getenv("DEBUG") == "1" {
		log.Printf("licenseStr: %s\n", licenseBytes)
	}

	// Sign the license using SHA1withRSA
	hashed := sha1.Sum(licenseBytes)
	signature, err := rsa.SignPKCS1v15(rand.Reader, privateKey, crypto.SHA1, hashed[:])
	if err != nil {
		return "", fmt.Errorf("failed to sign license: %w", err)
	}

	licensePartBase64 := base64.StdEncoding.EncodeToString(licenseBytes)
	signatureBase64 := base64.StdEncoding.EncodeToString(signature)
	crtBase64 := base64.StdEncoding.EncodeToString(crt.Raw)

	licenseResult := fmt.Sprintf("%s-%s-%s-%s", license.LicenseID, licensePartBase64, signatureBase64, crtBase64)
	if os.Getenv("DEBUG") == "1" {
		fmt.Printf("licenseResult: %s\n", licenseResult)
	}
	return licenseResult, nil
}
