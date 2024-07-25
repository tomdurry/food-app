package usecase

import (
	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/repository"
	"github.com/tomdurry/food-app/validator"
)

type IRecipeUsecase interface {
	GetAllRecipes(userId uint) ([]model.RecipeResponse, error)
	GetRecipeById(userId uint, recipeId uint) (model.RecipeResponse, error)
	FavoriteRecipe(recipe model.Recipe) (model.RecipeResponse, error)
	UnFavoriteRecipe(userId uint, recipeId uint) error
}

type recipeUsecase struct {
	rr repository.IRecipeRepository
	rv validator.IRecipeValidator
}

func NewRecipeUsecase(rr repository.IRecipeRepository, rv validator.IRecipeValidator) IRecipeUsecase {
	return &recipeUsecase{rr, rv}
}

func (ru *recipeUsecase) GetAllRecipes(userId uint) ([]model.RecipeResponse, error) {
	Recipes := []model.Recipe{}
	if err := ru.rr.GetAllRecipes(&Recipes, userId); err != nil {
		return nil, err
	}
	resRecipes := []model.RecipeResponse{}
	for _, v := range Recipes {
		t := model.RecipeResponse{
			ID:           v.ID,
			RecipeName:   v.RecipeName,
			Ingredients:  v.Ingredients,
			Instructions: v.Instructions,
			ImageUrl:     v.ImageUrl,
			CreatedAt:    v.CreatedAt,
			UpdatedAt:    v.UpdatedAt,
		}
		resRecipes = append(resRecipes, t)
	}
	return resRecipes, nil
}

func (ru *recipeUsecase) GetRecipeById(userId uint, recipeId uint) (model.RecipeResponse, error) {
	recipe := model.Recipe{}
	if err := ru.rr.GetRecipeById(&recipe, userId, recipeId); err != nil {
		return model.RecipeResponse{}, err
	}
	resRecipe := model.RecipeResponse{
		ID:           recipe.ID,
		RecipeName:   recipe.RecipeName,
		Ingredients:  recipe.Ingredients,
		Instructions: recipe.Instructions,
		ImageUrl:     recipe.ImageUrl,
		CreatedAt:    recipe.CreatedAt,
		UpdatedAt:    recipe.UpdatedAt,
	}
	return resRecipe, nil
}

func (ru *recipeUsecase) FavoriteRecipe(recipe model.Recipe) (model.RecipeResponse, error) {
	if err := ru.rv.RecipeValidate(recipe); err != nil {
		return model.RecipeResponse{}, err
	}
	if err := ru.rr.FavoriteRecipe(&recipe); err != nil {
		return model.RecipeResponse{}, err
	}
	resRecipe := model.RecipeResponse{
		ID:           recipe.ID,
		RecipeName:   recipe.RecipeName,
		Ingredients:  recipe.Ingredients,
		Instructions: recipe.Instructions,
		ImageUrl:     recipe.ImageUrl,
		CreatedAt:    recipe.CreatedAt,
		UpdatedAt:    recipe.UpdatedAt,
	}
	return resRecipe, nil
}

func (ru *recipeUsecase) UnFavoriteRecipe(userId uint, recipeId uint) error {
	if err := ru.rr.UnFavoriteRecipe(userId, recipeId); err != nil {
		return err
	}
	return nil
}
