package repository

import (
	"fmt"

	"github.com/tomdurry/food-app/model"

	"gorm.io/gorm"
)

type IRecipeRepository interface {
	GetAllRecipes(Recipes *[]model.Recipe, userId uint) error
	GetRecipeById(recipe *model.Recipe, userId uint, recipeId uint) error
	FavoriteRecipe(recipe *model.Recipe) error
	UnFavoriteRecipe(userId uint, recipeId uint) error
}

type recipeRepository struct {
	db *gorm.DB
}

func NewRecipeRepository(db *gorm.DB) IRecipeRepository {
	return &recipeRepository{db}
}

func (rr *recipeRepository) GetAllRecipes(Recipes *[]model.Recipe, userId uint) error {
	if err := rr.db.Joins("User").Where("user_id=?", userId).Order("created_at").Find(Recipes).Error; err != nil {
		return err
	}
	return nil
}

func (rr *recipeRepository) GetRecipeById(recipe *model.Recipe, userId uint, recipeId uint) error {
	if err := rr.db.Joins("User").Where("user_id=?", userId).First(recipe, recipeId).Error; err != nil {
		return err
	}
	return nil
}

func (rr *recipeRepository) FavoriteRecipe(recipe *model.Recipe) error {
	if err := rr.db.Create(recipe).Error; err != nil {
		return err
	}
	return nil
}

func (rr *recipeRepository) UnFavoriteRecipe(userId uint, recipeId uint) error {
	result := rr.db.Where("id=? AND user_id=?", recipeId, userId).Delete(&model.Recipe{})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected < 1 {
		return fmt.Errorf("object does not exist")
	}
	return nil
}
