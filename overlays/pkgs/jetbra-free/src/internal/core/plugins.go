package core

import (
	"encoding/json"
	"fmt"
	"jetbra-free/internal/util"
	"log"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"sync"
	"time"
)

const (
	pluginBaseUrl = "https://plugins.jetbrains.com"
)

var (
	binDir         = util.GetBinDir()
	certPath       = filepath.Join(binDir, ".jetbra-free", "jetbra.pem")
	keyPath        = filepath.Join(binDir, ".jetbra-free", "jetbra.key")
	powerPath      = filepath.Join(binDir, ".jetbra-free", "power.txt")
	jaNetfilter    = filepath.Join(binDir, ".jetbra-free", "static", "ja-netfilter", "ja-netfilter.jar")
	pluginJsonFile = filepath.Join(binDir, ".jetbra-free", "plugins.json")
	client         = http.Client{Timeout: 60 * time.Second}
	AllPluginList  []*Plugin
)

type ListPluginResponse struct {
	Plugins        []*Plugin `json:"plugins,omitempty"`
	CorrectedQuery string    `json:"correctedQuery,omitempty"`
	Total          int       `json:"total,omitempty"`
}

type Plugin struct {
	Code         string   `json:"code,omitempty"`
	Name         string   `json:"name"`
	PricingModel string   `json:"pricingModel"`
	Icon         string   `json:"icon"`
	Id           int      `json:"id"`
	IsFree       bool     `json:"isFree"`
	Describe     string   `json:"describe"`
	Tags         []string `json:"tags"`
	LicenseKey   string   `json:"licenseKey"`
	CrackStatus  string   `json:"crackstatus"`
}

type PluginDetail struct {
	PurchaseInfo struct {
		BuyUrl        any    `json:"buyUrl"`
		PurchaseTerms any    `json:"purchaseTerms"`
		ProductCode   string `json:"productCode"`
		TrialPeriod   int    `json:"trialPeriod"`
		Optional      bool   `json:"optional"`
	} `json:"purchaseInfo"`
	Id int `json:"id"`
}

func PluginsInit() {
	log.Printf("Start PluginsInit...")

	var skipFetch bool
	info, err := os.Stat(pluginJsonFile)
	if err == nil {
		modTime := info.ModTime()
		if time.Since(modTime) < 10*time.Minute {
			log.Printf("Skipping remote fetch because the plugin file was updated within the last 10 minutes.")
			skipFetch = true
		}
		pluginFile, err := os.OpenFile(pluginJsonFile, os.O_RDONLY, 0644)
		if err == nil {
			defer pluginFile.Close()
			err = json.NewDecoder(pluginFile).Decode(&AllPluginList)
			if err != nil {
				panic(err)
			}
		}
	}

	if !skipFetch {
		loadAllPlugin()
		savePlugin()
	}
	log.Printf("PluginsInit Finished")
}

func loadAllPlugin() {
	pluginIdCodeMap := make(map[int]string, len(AllPluginList))
	for _, plugin := range AllPluginList {
		pluginIdCodeMap[plugin.Id] = plugin.Code
	}

	var listPluginResponse ListPluginResponse
	pluginList, err := client.Get(pluginBaseUrl + "/api/searchPlugins?max=10000&offset=0")
	if err != nil {
		log.Printf("Failed to fetch plugin list from remote: %v", err)
		log.Printf("Trying to load plugin list from cache...")
		cacheFile := filepath.Join(binDir, ".jetbra-free", "cache", "searchPlugins.json")
		cachedData, err := os.ReadFile(cacheFile)
		if err != nil {
			log.Printf("Failed to read cache file: %v", err)
			return
		}
		err = json.Unmarshal(cachedData, &listPluginResponse)
		if err != nil {
			log.Printf("Failed to parse cache data: %v", err)
			return
		}
		log.Printf("Loaded plugin list from cache.")
	} else {
		defer pluginList.Body.Close()
		err = json.NewDecoder(pluginList.Body).Decode(&listPluginResponse)
		if err != nil {
			log.Printf("Failed to decode plugin list response: %v", err)
			return
		}
		cacheDir := filepath.Join(binDir, ".jetbra-free", "cache")
		os.MkdirAll(cacheDir, 0755)
		cacheFile := filepath.Join(cacheDir, "searchPlugins.json")
		cacheData, _ := json.Marshal(listPluginResponse)
		os.WriteFile(cacheFile, cacheData, 0644)
	}

	for i, plugin := range listPluginResponse.Plugins {
		if plugin.PricingModel == "FREE" {
			continue
		}
		if pluginIdCodeMap[plugin.Id] != "" {
			continue
		}
		if os.Getenv("DEBUG") != "" {
			fmt.Println("found new plugin ", plugin.Name, "|", plugin.PricingModel)
		}
		if plugin.Icon == "" || plugin.Icon == "https://plugins.jetbrains.com" {
			listPluginResponse.Plugins[i].Icon = path.Join("static", "icons", "Plugin_icon.svg")
		} else {
			listPluginResponse.Plugins[i].Icon = pluginBaseUrl + listPluginResponse.Plugins[i].Icon
		}
		AllPluginList = append(AllPluginList, listPluginResponse.Plugins[i])
	}
	found := false
	for _, plugin := range AllPluginList {
		if plugin.Name == "dotCover" {
			found = true
			break
		}
	}
	if !found {
		AllPluginList = append(AllPluginList, &Plugin{
			Name: "dotCover",
			Code: "DC",
			Icon: path.Join("static", "icons", "dotCover_icon.svg"),
			Tags: []string{"C#", ".NET", "ASP.NET"},
		})
		log.Println("Inserted new plugin: dotCover")
	} else {
		log.Println("dotCover plugin already exists, skipping insertion.")
	}
	var wg sync.WaitGroup
	codeChan := make(chan struct {
		idx  int
		code string
	}, len(AllPluginList))

	for idx, plugin := range AllPluginList {
		if plugin.Code == "" {
			wg.Add(1)
			go func(i int, id int, name string) {
				defer wg.Done()
				code := getCodeByPluginID(id)
				fmt.Println("new plugin code ", name, "|", code)
				codeChan <- struct {
					idx  int
					code string
				}{i, code}
			}(idx, plugin.Id, plugin.Name)
		}
	}

	go func() {
		wg.Wait()
		close(codeChan)
	}()

	for item := range codeChan {
		AllPluginList[item.idx].Code = item.code
	}
}

func getCodeByPluginID(id int) string {
	var pluginDetail PluginDetail
	cacheDir := filepath.Join(binDir, ".jetbra-free", "cache", "plugins")
	os.MkdirAll(cacheDir, 0755)
	cacheFile := filepath.Join(cacheDir, fmt.Sprintf("%d.json", id))
	pluginDetailResp, err := client.Get(pluginBaseUrl + "/api/plugins/" + strconv.Itoa(id))
	if err != nil {
		log.Printf("Failed to fetch plugin code from remote: %v", err)
		log.Printf("Trying to load plugin detail from cache...")

		cachedData, err := os.ReadFile(cacheFile)
		if err != nil {
			log.Printf("Failed to read cache file: %v", err)
			return ""
		}
		err = json.Unmarshal(cachedData, &pluginDetail)
		if err != nil {
			log.Printf("Failed to parse cache data: %v", err)
			return ""
		}
	} else {
		defer pluginDetailResp.Body.Close()
		err = json.NewDecoder(pluginDetailResp.Body).Decode(&pluginDetail)
		if err != nil {
			log.Printf("Failed to parse plugin detail for ID %d: %v", id, err)
			return ""
		}
		cacheData, _ := json.Marshal(pluginDetail)
		os.WriteFile(cacheFile, cacheData, 0644)
	}
	return pluginDetail.PurchaseInfo.ProductCode
}

func savePlugin() {
	f, err := os.Create(pluginJsonFile)
	if err != nil {
		panic(err)
	}
	err = json.NewEncoder(f).Encode(AllPluginList)
	if err != nil {
		panic(err)
	}
}
