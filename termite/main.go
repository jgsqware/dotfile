package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"os"

	colorful "github.com/lucasb-eyer/go-colorful"
)

type ITermTheme struct {
	ColorKey    []string  `xml:"dict>key"`
	Nuance      []string  `xml:"dict>dict>key"`
	NuanceValue []float64 `xml:"dict>dict>real"`
}

var colorsMap = map[string]string{"Ansi 0 Color": "color0",
	"Ansi 1 Color":        "color1",
	"Ansi 10 Color":       "color10",
	"Ansi 11 Color":       "color11",
	"Ansi 12 Color":       "color12",
	"Ansi 13 Color":       "color13",
	"Ansi 14 Color":       "color14",
	"Ansi 15 Color":       "color15",
	"Ansi 2 Color":        "color2",
	"Ansi 3 Color":        "color3",
	"Ansi 4 Color":        "color4",
	"Ansi 5 Color":        "color5",
	"Ansi 6 Color":        "color6",
	"Ansi 7 Color":        "color7",
	"Ansi 8 Color":        "color8",
	"Ansi 9 Color":        "color9",
	"Background Color":    "background",
	"Badge Color":         "foreground",
	"Bold Color":          "foreground_bold",
	"Cursor Color":        "cursor",
	"Cursor Guide Color":  "cursor",
	"Cursor Text Color":   "cursor",
	"Foreground Color":    "foreground",
	"Link Color":          "foreground",
	"Selected Text Color": "cursor_foreground",
	"Selection Color":     "cursor_foreground",
	"Tab Color":           "foreground",
}

func main() {
	xmlFile, err := os.Open("cyberpunk.xml")
	if err != nil {
		fmt.Println(err)
	}
	defer xmlFile.Close()

	byteValue, _ := ioutil.ReadAll(xmlFile)
	var itermTheme ITermTheme
	xml.Unmarshal(byteValue, &itermTheme)
	for i, color := range itermTheme.ColorKey {

		c := colorful.Color{
			R: itermTheme.NuanceValue[i*4+3],
			G: itermTheme.NuanceValue[i*4+2],
			B: itermTheme.NuanceValue[i*4+1],
		}
		fmt.Printf("%s = %s\n", colorsMap[color], c.Hex())
	}
}
