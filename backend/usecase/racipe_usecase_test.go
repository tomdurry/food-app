package usecase_test

import (
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"

	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/usecase"
)

type MockRecipeRepository struct {
	mock.Mock
}

type MockRecipeValidator struct {
	mock.Mock
}

func (m *MockRecipeRepository) GetAllRecipes(recipes *[]model.Recipe, userId uint) error {
	args := m.Called(recipes, userId)
	return args.Error(0)
}

func (m *MockRecipeRepository) GetRecipeById(recipe *model.Recipe, userId uint, recipeId uint) error {
	args := m.Called(recipe, userId, recipeId)
	return args.Error(0)
}

func (m *MockRecipeRepository) FavoriteRecipe(recipe *model.Recipe) error {
	args := m.Called(recipe)
	return args.Error(0)
}

func (m *MockRecipeRepository) UnFavoriteRecipe(userId uint, recipeId uint) error {
	args := m.Called(userId, recipeId)
	return args.Error(0)
}

func (m *MockRecipeValidator) RecipeValidate(recipe model.Recipe) error {
	args := m.Called(recipe)
	return args.Error(0)
}

func TestGetAllRecipes(t *testing.T) {
	repo := new(MockRecipeRepository)
	validator := new(MockRecipeValidator)
	uc := usecase.NewRecipeUsecase(repo, validator)

	recipes := []model.Recipe{{ID: 1, RecipeName: "Pasta"}}
	repo.On("GetAllRecipes", mock.Anything, uint(1)).Return(nil).Run(func(args mock.Arguments) {
		arg := args.Get(0).(*[]model.Recipe)
		*arg = recipes
	})

	res, err := uc.GetAllRecipes(1)
	assert.NoError(t, err)
	assert.Len(t, res, 1)
	assert.Equal(t, "Pasta", res[0].RecipeName)
}

func TestGetRecipeById(t *testing.T) {
	repo := new(MockRecipeRepository)
	validator := new(MockRecipeValidator)
	uc := usecase.NewRecipeUsecase(repo, validator)

	recipe := model.Recipe{ID: 1, RecipeName: "Pasta"}
	repo.On("GetRecipeById", mock.Anything, uint(1), uint(1)).Return(nil).Run(func(args mock.Arguments) {
		arg := args.Get(0).(*model.Recipe)
		*arg = recipe
	})

	res, err := uc.GetRecipeById(1, 1)
	assert.NoError(t, err)
	assert.Equal(t, "Pasta", res.RecipeName)
}

func TestFavoriteRecipe(t *testing.T) {
	repo := new(MockRecipeRepository)
	validator := new(MockRecipeValidator)
	uc := usecase.NewRecipeUsecase(repo, validator)

	recipe := model.Recipe{ID: 1, RecipeName: "Pasta"}

	validator.On("RecipeValidate", recipe).Return(nil)
	repo.On("FavoriteRecipe", &recipe).Return(nil)

	res, err := uc.FavoriteRecipe(recipe)
	assert.NoError(t, err)
	assert.Equal(t, "Pasta", res.RecipeName)
}

func TestUnFavoriteRecipe(t *testing.T) {
	repo := new(MockRecipeRepository)
	validator := new(MockRecipeValidator)
	uc := usecase.NewRecipeUsecase(repo, validator)

	repo.On("UnFavoriteRecipe", uint(1), uint(1)).Return(nil)

	err := uc.UnFavoriteRecipe(1, 1)
	assert.NoError(t, err)
}

func TestGetAllRecipes_Error(t *testing.T) {
	repo := new(MockRecipeRepository)
	validator := new(MockRecipeValidator)
	uc := usecase.NewRecipeUsecase(repo, validator)

	repo.On("GetAllRecipes", mock.Anything, uint(1)).Return(errors.New("database error"))

	res, err := uc.GetAllRecipes(1)
	assert.Error(t, err)
	assert.Nil(t, res)
}
