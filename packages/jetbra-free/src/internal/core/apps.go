package core

import (
	"jetbra-free/internal/util"
	"net/http"
	"path"
	"time"

	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	expiryDate := time.Now().AddDate(10, 0, 0).Format("2006-01-02")

	apps := []Plugin{
		{Name: "IntelliJ IDEA", Code: "II,PCWMP,PSI", Icon: path.Join("static", "icons", "IntelliJ_IDEA_icon.svg"), IsFree: false, Describe: "IDE for Java and Kotlin developers", Tags: []string{"Java", "Kotlin", "Spring"}, CrackStatus: GetCrackStatus("IntelliJIdea")},
		{Name: "PyCharm", Code: "PC,PCWMP,PSI", Icon: path.Join("static", "icons", "PyCharm_icon.svg"), IsFree: false, Describe: "IDE for Python developers and data scientists", Tags: []string{"Python", "Django", "Jupyter"}, CrackStatus: GetCrackStatus("PyCharm")},
		{Name: "PhpStorm", Code: "PS,PCWMP,PSI", Icon: path.Join("static", "icons", "PhpStorm_icon.svg"), IsFree: false, Describe: "IDE for PHP developers", Tags: []string{"PHP", "Laravel", "Symfony"}, CrackStatus: GetCrackStatus("PhpStorm")},
		{Name: "GoLand", Code: "GO,PCWMP,PSI", Icon: path.Join("static", "icons", "GoLand_icon.svg"), IsFree: false, Describe: "IDE for Go developers", Tags: []string{"Go (Golang)", "JavaScript", "TypeScript"}, CrackStatus: GetCrackStatus("GoLand")},
		{Name: "DataGrip", Code: "DB,PSI", Icon: path.Join("static", "icons", "DataGrip_icon.svg"), IsFree: false, Describe: "Tool for multiple databases", Tags: []string{"Databases", "SQL", "NoSQL"}, CrackStatus: GetCrackStatus("DataGrip")},
		{Name: "DataSpell", Code: "DS,PCWMP,PSI", Icon: path.Join("static", "icons", "DataSpell_icon.svg"), IsFree: false, Describe: "Tool for data analysis", Tags: []string{"Databases", "SQL", "NoSQL"}, CrackStatus: GetCrackStatus("DataSpell")},
		{Name: "RubyMine", Code: "RM,PCWMP,PSI", Icon: path.Join("static", "icons", "RubyMine_icon.svg"), IsFree: false, Describe: "IDE for Ruby and Rails developers", Tags: []string{"Ruby on Rails (RoR)", "Hotwire", "RuboCop"}, CrackStatus: GetCrackStatus("RubyMine")},
		{Name: "Rider", Code: "RD,DC,DPN,PCWMP,PSI", Icon: path.Join("static", "icons", "Rider_icon.svg"), IsFree: true, Describe: "IDE for .NET and game developers", Tags: []string{"C#", ".NET", "ASP.NET"}, CrackStatus: GetCrackStatus("Rider")},
		{Name: "CLion", Code: "CL,PCWMP,PSI", Icon: path.Join("static", "icons", "CLion_icon.svg"), IsFree: true, Describe: "IDE for C and C++ developers", Tags: []string{"C", "C++", "CMake"}, CrackStatus: GetCrackStatus("CLion")},
		{Name: "RustRover", Code: "RR,PCWMP,PSI", Icon: path.Join("static", "icons", "RustRover_icon.svg"), IsFree: true, Describe: "IDE for Rust developers", Tags: []string{"Rust", "SQL", "JavaScript"}, CrackStatus: GetCrackStatus("RustRover")},
		{Name: "WebStorm", Code: "WS,PCWMP,PSI", Icon: path.Join("static", "icons", "WebStorm_icon.svg"), IsFree: true, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		// {Name: "AppCode", Code: "AC,PCWMP,PSI", Icon: filepath.Join("static", "icons", "AppCode_icon.svg"), IsFree: false, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		// {Name: "dotCover", Code: "DC", Icon: filepath.Join("static", "icons", "dotCover_icon.svg"), IsFree: false, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		// {Name: "dotTrace", Code: "DPN", Icon: filepath.Join("static", "icons", "dotTrace_icon.svg"), IsFree: false, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		// {Name: "dotMemory", Code: "DM", Icon: filepath.Join("static", "icons", "dotMemory_icon.svg"), IsFree: false, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		// {Name: "Aqua", Code: "AQ", Icon: filepath.Join("static", "icons", "Aaqua_icon.svg"), IsFree: false, Describe: "IDE for JavaScript and TypeScript developers", Tags: []string{"JavaScript", "TypeScript", "React"}, CrackStatus: GetCrackStatus("WebStorm")},
		//
		// DEVECOSTUDIO_VM_OPTIONS
		// GATEWAY_VM_OPTIONS
		// JETBRAINS_CLIENT_VM_OPTIONS
		// JETBRAINSCLIENT_VM_OPTIONS
		// STUDIO_VM_OPTIONS Android studio
		// WEBIDE_VM_OPTIONS
	}

	c.HTML(http.StatusOK, "/index.html", gin.H{
		"title":        "License Generator",
		"licenseeName": "Evaluator",
		"assigneeName": "Evaluator",
		"expiryDate":   expiryDate,
		"apps":         apps,
		"plugins":      AllPluginList,
		"jaNetfilter":  jaNetfilter,
		"checkenv":     util.GetVMOptionsVars(),
	})
}
