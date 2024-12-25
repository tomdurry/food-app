package migrate

import (
	"fmt"

	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/model"
)

func Run() {
	dbConn := db.NewDB()
	defer fmt.Println("Successfully Migrated")
	defer db.CloseDB(dbConn)
	dbConn.AutoMigrate(&model.User{}, &model.Recipe{})
}
