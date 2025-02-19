package validator_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/validator"
)

func TestRecipeValidate(t *testing.T) {
	validator := validator.NewRecipeValidator()

	t.Run("Valid Recipe", func(t *testing.T) {
		validRecipe := model.Recipe{RecipeName: "Pasta"}
		err := validator.RecipeValidate(validRecipe)
		assert.NoError(t, err)
	})

	t.Run("Invalid Recipe", func(t *testing.T) {
		invalidRecipe := model.Recipe{RecipeName: ""}
		err := validator.RecipeValidate(invalidRecipe)
		assert.Error(t, err)
		assert.Contains(t, err.Error(), "RecipeName is required")
	})
}

func TestUserValidate(t *testing.T) {
	validator := validator.NewUserValidator()

	t.Run("Valid User", func(t *testing.T) {
		validUser := model.User{LoginId: "test_user", Password: "securePass123"}
		err := validator.UserValidate(validUser)
		assert.NoError(t, err)
	})

	t.Run("Invalid Users", func(t *testing.T) {
		invalidUsers := []struct {
			user          model.User
			expectedError string
		}{
			{model.User{LoginId: "", Password: "password123"}, "ログインIDは必須です"},
			{model.User{LoginId: "longusernamethatisinvalid", Password: "password123"}, "ログインIDは最大16文字です"},
			{model.User{LoginId: "invalid!user", Password: "password123"}, "ログインIDは英数字とアンダースコア (_) のみ使用可能です"},
			{model.User{LoginId: "valid_user", Password: "short"}, "パスワードは6文字から30文字で設定してください"},
		}

		for _, tc := range invalidUsers {
			err := validator.UserValidate(tc.user)
			assert.Error(t, err)
			assert.Contains(t, err.Error(), tc.expectedError)
		}
	})
}
