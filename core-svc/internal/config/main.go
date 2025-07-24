package config

import (
	env "github.com/joho/godotenv"
	"log"
	"os"
)

type CoreConfig struct {
	DatabaseUrl string
	AuthSecret  string
}

func loadEnvironment() {
	err := env.Load(".env")
	if err != nil {
		log.Fatal("Unable to load the core enviroment file")
		panic(".env" + err.Error())
	}

}

func GetCoreConfig() CoreConfig {

	loadEnvironment()
	DatabaseUrl := os.Getenv("DATABASE_URL")

	return CoreConfig{DatabaseUrl: DatabaseUrl, AuthSecret: "ajhwdvawhujydfgiuqw3"}
}
