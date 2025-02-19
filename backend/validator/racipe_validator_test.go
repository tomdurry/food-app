package validator_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/validator"
)

func TestRecipeValidate_Valid(t *testing.T) {
	validator := validator.NewRecipeValidator()
	validRecipe := model.Recipe{RecipeName: "Pasta"}

	err := validator.RecipeValidate(validRecipe)
	assert.NoError(t, err)
}

func TestRecipeValidate_Invalid(t *testing.T) {
	validator := validator.NewRecipeValidator()
	invalidRecipe := model.Recipe{RecipeName: ""}

	err := validator.RecipeValidate(invalidRecipe)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "RecipeName is required")
}
