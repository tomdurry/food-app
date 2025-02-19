package controller_test

import (
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"

	"github.com/tomdurry/food-app/controller"
	"github.com/tomdurry/food-app/model"
)

type MockRecipeUsecase struct {
	mock.Mock
}

func (m *MockRecipeUsecase) GetAllRecipes(userId uint) ([]model.RecipeResponse, error) {
	args := m.Called(userId)
	recipes, ok := args.Get(0).([]model.RecipeResponse)
	if !ok {
		return nil, errors.New("type assertion to []model.RecipeResponse failed")
	}
	return recipes, args.Error(1)
}

func (m *MockRecipeUsecase) GetRecipeById(userId, recipeId uint) (model.RecipeResponse, error) {
	args := m.Called(userId, recipeId)
	recipeRes, ok := args.Get(0).(model.RecipeResponse)
	if !ok {
		return model.RecipeResponse{}, errors.New("type assertion to model.RecipeResponse failed")
	}
	return recipeRes, args.Error(1)
}

func (m *MockRecipeUsecase) FavoriteRecipe(recipe model.Recipe) (model.RecipeResponse, error) {
	args := m.Called(recipe)
	recipeRes, ok := args.Get(0).(model.RecipeResponse)
	if !ok {
		return model.RecipeResponse{}, errors.New("type assertion to model.RecipeResponse failed")
	}
	return recipeRes, args.Error(1)
}

func (m *MockRecipeUsecase) UnFavoriteRecipe(userId, recipeId uint) error {
	args := m.Called(userId, recipeId)
	return args.Error(0)
}

func setupTestController() (controller.IRecipeController, *MockRecipeUsecase, *echo.Echo) {
	mockUsecase := new(MockRecipeUsecase)
	recipeController := controller.NewRecipeController(mockUsecase)
	e := echo.New()
	return recipeController, mockUsecase, e
}

func generateJWT() *jwt.Token {
	return &jwt.Token{
		Claims: jwt.MapClaims{
			"user_id": float64(1),
		},
	}
}

func TestGetAllRecipes(t *testing.T) {
	controller, mockUsecase, e := setupTestController()
	mockRecipesRes := []model.RecipeResponse{
		{
			ID:           1,
			RecipeName:   "Pasta",
			Ingredients:  json.RawMessage("null"),
			Instructions: json.RawMessage("null"),
		},
	}
	mockUsecase.On("GetAllRecipes", uint(1)).Return(mockRecipesRes, nil)

	req := httptest.NewRequest(http.MethodGet, "/recipes", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)
	c.Set("user", generateJWT())

	if assert.NoError(t, controller.GetAllRecipes(c)) {
		assert.Equal(t, http.StatusOK, res.Code)
		var response []model.RecipeResponse
		json.Unmarshal(res.Body.Bytes(), &response)
		assert.Equal(t, mockRecipesRes, response)
	}
}

func TestGetRecipeById(t *testing.T) {
	controller, mockUsecase, e := setupTestController()
	mockRecipeRes := model.RecipeResponse{
		ID:           1,
		RecipeName:   "Pasta",
		Ingredients:  json.RawMessage("null"),
		Instructions: json.RawMessage("null"),
	}
	mockUsecase.On("GetRecipeById", uint(1), uint(1)).Return(mockRecipeRes, nil)

	req := httptest.NewRequest(http.MethodGet, "/recipes/1", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)
	c.Set("user", generateJWT())
	c.SetParamNames("recipeId")
	c.SetParamValues(strconv.Itoa(1))

	if assert.NoError(t, controller.GetRecipeById(c)) {
		assert.Equal(t, http.StatusOK, res.Code)
		var response model.RecipeResponse
		json.Unmarshal(res.Body.Bytes(), &response)
		assert.Equal(t, mockRecipeRes, response)
	}
}

func TestFavoriteRecipe(t *testing.T) {
	controller, mockUsecase, e := setupTestController()
	mockRecipeRes := model.RecipeResponse{ID: 1, RecipeName: "Pasta"}
	mockUsecase.On("FavoriteRecipe", mock.Anything).Return(mockRecipeRes, nil)

	req := httptest.NewRequest(http.MethodPost, "/recipes/favorite", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)
	c.Set("user", generateJWT())

	if assert.NoError(t, controller.FavoriteRecipe(c)) {
		assert.Equal(t, http.StatusCreated, res.Code)
	}
}

func TestUnFavoriteRecipe(t *testing.T) {
	controller, mockUsecase, e := setupTestController()
	mockUsecase.On("UnFavoriteRecipe", uint(1), uint(1)).Return(nil)

	req := httptest.NewRequest(http.MethodDelete, "/recipes/1/unfavorite", nil)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)
	c.Set("user", generateJWT())
	c.SetParamNames("recipeId")
	c.SetParamValues(strconv.Itoa(1))

	if assert.NoError(t, controller.UnFavoriteRecipe(c)) {
		assert.Equal(t, http.StatusNoContent, res.Code)
	}
}
