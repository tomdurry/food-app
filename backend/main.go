package main

import (
	"github.com/tomdurry/food-app/controller"
	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/migrate"
	"github.com/tomdurry/food-app/repository"
	"github.com/tomdurry/food-app/router"
	"github.com/tomdurry/food-app/usecase"
	"github.com/tomdurry/food-app/validator"
)

func main() {
	migrate.Run()
	db := db.NewDB()
	userValidator := validator.NewUserValidator()
	recipeValidator := validator.NewRecipeValidator()
	userRepository := repository.NewUserRepository(db)
	recipeRepository := repository.NewRecipeRepository(db)
	userUsecase := usecase.NewUserUsecase(userRepository, userValidator)
	recipeUsecase := usecase.NewRecipeUsecase(recipeRepository, recipeValidator)
	userController := controller.NewUserController(userUsecase)
	recipeController := controller.NewRecipeController(recipeUsecase)
	e := router.NewRouter(userController, recipeController)
	e.Logger.Fatal(e.Start(":8080"))
}
