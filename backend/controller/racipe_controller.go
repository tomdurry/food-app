package controller

import (
	"net/http"
	"strconv"

	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/usecase"

	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
)

type IRecipeController interface {
	GetAllRecipes(c echo.Context) error
	GetRecipeById(c echo.Context) error
	FavoriteRecipe(c echo.Context) error
	UnFavoriteRecipe(c echo.Context) error
}

type recipeController struct {
	ru usecase.IRecipeUsecase
}

func NewRecipeController(ru usecase.IRecipeUsecase) IRecipeController {
	return &recipeController{ru}
}

func (rc *recipeController) GetAllRecipes(c echo.Context) error {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userId := claims["user_id"]

	RecipesRes, err := rc.ru.GetAllRecipes(uint(userId.(float64)))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, RecipesRes)
}

func (rc *recipeController) GetRecipeById(c echo.Context) error {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userId := claims["user_id"]
	id := c.Param("recipeId")
	recipeId, _ := strconv.Atoi(id)
	recipeRes, err := rc.ru.GetRecipeById(uint(userId.(float64)), uint(recipeId))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, recipeRes)
}

func (rc *recipeController) FavoriteRecipe(c echo.Context) error {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userId := claims["user_id"]

	recipe := model.Recipe{}
	if err := c.Bind(&recipe); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	recipe.UserId = uint(userId.(float64))
	recipeRes, err := rc.ru.FavoriteRecipe(recipe)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, recipeRes)
}

func (rc *recipeController) UnFavoriteRecipe(c echo.Context) error {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userId := claims["user_id"]
	id := c.Param("recipeId")
	recipeId, _ := strconv.Atoi(id)

	err := rc.ru.UnFavoriteRecipe(uint(userId.(float64)), uint(recipeId))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.NoContent(http.StatusNoContent)
}
