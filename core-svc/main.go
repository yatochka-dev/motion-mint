package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v5"
	mmv1c "github.com/yatochka-dev/motion-mint/core-svc/gen/go/v1/motionmintv1connect"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/config"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/db/repository"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/service/auth"
	tokenservice "github.com/yatochka-dev/motion-mint/core-svc/internal/service/token"
	transportAuth "github.com/yatochka-dev/motion-mint/core-svc/internal/transport/auth"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"net/http"
)

var ctx = context.Background()

func main() {
	fmt.Println("So much to do....")

	c := config.GetCoreConfig()

	/* -------------- DB CONNECTION ----------------*/
	conn, err := pgx.Connect(context.Background(), c.DatabaseUrl)
	if err != nil {
		panic(err)
	}
	defer conn.Close(ctx)
	repo := repository.New(conn)

	d := repo.Test(ctx)
	fmt.Println(d)
	/* -------------- AUTH SERVICE ----------------*/
	tokenSvc := tokenservice.NewTokenService(&c)
	authSvc := auth.NewService(repo, tokenSvc)
	authImpl := transportAuth.New(authSvc)                         // implements mmv1c.AuthServiceHandler
	authPath, authHandler := mmv1c.NewAuthServiceHandler(authImpl) // HTTP handler + route

	/* -------------- ASSIGN HANDLERS ----------------*/
	mux := http.NewServeMux()
	mux.Handle(authPath, authHandler)

	/* -------------- START SERVER ----------------*/
	err = http.ListenAndServe(":8080", h2c.NewHandler(mux, &http2.Server{}))

	if err != nil {
		panic(err)
	}
}
