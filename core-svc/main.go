package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v5"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/config"
)

var ctx = context.Background()

func main() {
	fmt.Println("So much to do....")

	c := config.GetCoreConfig()
	fmt.Println(c)
	conn, err := pgx.Connect(context.Background(), c.DATABASE_URL)
	if err != nil {
		panic(err)
	}
	defer conn.Close(ctx)

}
