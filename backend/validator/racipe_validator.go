package validator

import (
	"github.com/tomdurry/food-app/model"

	validation "github.com/go-ozzo/ozzo-validation/v4"
)

type IRecipeValidator interface {
	RecipeValidate(recipe model.Recipe) error
}

type recipeValidator struct{}

func NewRecipeValidator() IRecipeValidator {
	return &recipeValidator{}
}

func (rv *recipeValidator) RecipeValidate(recipe model.Recipe) error {
	return validation.ValidateStruct(&recipe,
		validation.Field(
			&recipe.RecipeName,
			validation.Required.Error("RecipeName is required"),
		),
	)
}
