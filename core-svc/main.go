package main

import (
	"context"
	"fmt"
	config "github.com/yatochka-dev/motion-mint/core-svc/internal/config"
)

var ctx = context.Background()

func main() {
	fmt.Println("So much to do....")

	config := config.GetCoreConfig()
}
