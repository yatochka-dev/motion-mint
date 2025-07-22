package config

import (
	env "github.com/joho/godotenv"
	"log"
	"os"
)

type CoreConfig struct {
	DATABASE_URL string
}

func loadEnviroment() {
	err := env.Load("./../../.env")
	if err != nil {
		log.Fatal("Unable to load the core enviroment file")
		panic(".env" + err.Error())
	}

}
func GetCoreConfig() CoreConfig {

	loadEnviroment()
	DatabaseUrl := os.Getenv("DATABASE_URL")

	return CoreConfig{DATABASE_URL: DatabaseUrl}
}
