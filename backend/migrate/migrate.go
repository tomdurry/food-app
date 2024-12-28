package main

import (
	"fmt"
	"log"

	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/model"
)

func main() {
	dbConn := db.NewDB()
	defer db.CloseDB(dbConn)
	fmt.Println("Running migrations...")
	err := dbConn.AutoMigrate(&model.User{}, &model.Recipe{})
	if err != nil {
		log.Fatalf("Migration failed: %v", err)
	}
	fmt.Println("Successfully Migrated")
}
