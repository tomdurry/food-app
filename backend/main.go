package main

import (
	"github.com/tomdurry/food-app/controller"
	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/repository"
	"github.com/tomdurry/food-app/router"
	"github.com/tomdurry/food-app/usecase"
)

func main() {
	db := db.NewDB()
	userRepository := repository.NewUserRepository(db)
	userUsecase := usecase.NewUserUsecase(userRepository)
	userController := controller.NewUserController(userUsecase)
	e := router.NewRouter(userController)
	e.Logger.Fatal(e.Start(":8080"))
}
