package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"github.com/tomdurry/food-app/controller"
	"github.com/tomdurry/food-app/db"
	"github.com/tomdurry/food-app/repository"
	"github.com/tomdurry/food-app/router"
	"github.com/tomdurry/food-app/usecase"
	"github.com/tomdurry/food-app/validator"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func setupMockDB() {
	mockDB, _, _ := sqlmock.New()
	gormDB, _ := gorm.Open(postgres.New(postgres.Config{
		Conn: mockDB,
	}), &gorm.Config{})
	db.TestDB = gormDB
}

func TestMain(m *testing.M) {
	setupMockDB()
	m.Run()
}

func setupTestServer() *echo.Echo {
	testDB := db.NewDB()

	userValidator := validator.NewUserValidator()
	recipeValidator := validator.NewRecipeValidator()
	userRepository := repository.NewUserRepository(testDB)
	recipeRepository := repository.NewRecipeRepository(testDB)
	userUsecase := usecase.NewUserUsecase(userRepository, userValidator)
	recipeUsecase := usecase.NewRecipeUsecase(recipeRepository, recipeValidator)
	userController := controller.NewUserController(userUsecase)
	recipeController := controller.NewRecipeController(recipeUsecase)
	e := router.NewRouter(userController, recipeController)

	return e
}

func TestServerStart(t *testing.T) {
	e := setupTestServer()

	testCases := []struct {
		method string
		route  string
	}{
		{http.MethodGet, "/health"},
		{http.MethodPost, "/signup"},
		{http.MethodPost, "/login"},
		{http.MethodPost, "/logout"},
		{http.MethodGet, "/csrf"},
	}

	for _, tc := range testCases {
		req := httptest.NewRequest(tc.method, tc.route, nil)
		rec := httptest.NewRecorder()
		e.ServeHTTP(rec, req)

		assert.NotEqual(t, http.StatusNotFound, rec.Code, "エンドポイント %s が存在しない", tc.route)
	}
}

func TestHealthCheck(t *testing.T) {
	e := setupTestServer()

	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	assert.Equal(t, http.StatusOK, rec.Code, "ヘルスチェックAPIが正しく動作しているか確認")
}
