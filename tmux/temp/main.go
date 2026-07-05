package main

import (
	"fmt"
	"os"

	"github.com/shirou/gopsutil/v3/host"
)

func main() {
	temps, err := host.SensorsTemperatures()
	if err != nil {
		os.Exit(1)
	}

	for _, temp := range temps {
		// TC0P is your CPU Proximity sensor based on your output
		if temp.SensorKey == "TC0P" && temp.Temperature > 0 {
			fmt.Printf("%.1f°C\n", temp.Temperature)
			return
		}
	}
	
	os.Exit(1)
}
