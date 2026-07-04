// `temp` is a simple CLI for checking cpu temperature on mac.
// NOTE: use osx-cpu-temp instead.
// ...this was built to aviod the need to install other tools

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

	// temp for MacOS
	for _, temp := range temps {
		if temp.SensorKey == "TC0P" && temp.Temperature > 0 {
			fmt.Printf("%.1f°C\n", temp.Temperature)
			return
		}
	}

	os.Exit(1)
}
