package repository_test

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/repository"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func setupMockDB() (*gorm.DB, sqlmock.Sqlmock) {
	db, mock, err := sqlmock.New()
	if err != nil {
		panic("failed to create sqlmock database")
	}
	gormDB, err := gorm.Open(postgres.New(postgres.Config{Conn: db}), &gorm.Config{})
	if err != nil {
		panic("failed to create gorm database")
	}
	return gormDB, mock
}

func TestGetAllRecipes(t *testing.T) {
	db, mock := setupMockDB()
	repo := repository.NewRecipeRepository(db)

	var recipes []model.Recipe
	userId := uint(1)

	ingredientsJSON, _ := json.Marshal([]model.Ingredient{{Ingredient: "Salt", Quantity: "1 tsp"}})
	instructionsJSON, _ := json.Marshal([]string{"Step 1", "Step 2"})

	now := time.Now()

	mock.ExpectQuery(`SELECT .* FROM "recipes" LEFT JOIN "users" "User" ON "recipes"."user_id" = "User"."id" WHERE user_id=\$1 ORDER BY created_at`).
		WithArgs(userId).
		WillReturnRows(sqlmock.NewRows([]string{
			"id", "recipe_name", "ingredients", "instructions", "image_url", "created_at", "updated_at", "user_id",
		}).
			AddRow(1, "Recipe 1", ingredientsJSON, instructionsJSON, "image1.jpg", now, now, userId).
			AddRow(2, "Recipe 2", ingredientsJSON, instructionsJSON, "image2.jpg", now, now, userId))

	err := repo.GetAllRecipes(&recipes, userId)

	assert.NoError(t, err)
	assert.Len(t, recipes, 2)
	assert.Equal(t, "Recipe 1", recipes[0].RecipeName)
}

func TestUnFavoriteRecipe(t *testing.T) {
	db, mock := setupMockDB()
	repo := repository.NewRecipeRepository(db)

	userId := uint(1)
	recipeId := uint(10)

	mock.ExpectBegin()
	mock.ExpectExec(`DELETE FROM "recipes" WHERE id=\$1 AND user_id=\$2`).
		WithArgs(recipeId, userId).
		WillReturnResult(sqlmock.NewResult(0, 1))
	mock.ExpectCommit()

	err := repo.UnFavoriteRecipe(userId, recipeId)

	assert.NoError(t, err)
}
