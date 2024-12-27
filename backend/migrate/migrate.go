package main

import (
	"fmt"

	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/model"
)

func main() {
	dbConn := db.NewDB()
	defer db.CloseDB(dbConn)
	fmt.Println("Running migrations...")
	dbConn.AutoMigrate(&model.User{}, &model.Recipe{})
	fmt.Println("Successfully Migrated")
}
