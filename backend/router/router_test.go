package router

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

type MockUserController struct{}

func (m *MockUserController) SignUp(c echo.Context) error { return c.NoContent(http.StatusOK) }
func (m *MockUserController) LogIn(c echo.Context) error  { return c.NoContent(http.StatusOK) }
func (m *MockUserController) LogOut(c echo.Context) error { return c.NoContent(http.StatusOK) }
func (m *MockUserController) CsrfToken(c echo.Context) error {
	return c.String(http.StatusOK, "csrf_token")
}

type MockRecipeController struct{}

func (m *MockRecipeController) GetAllRecipes(c echo.Context) error { return c.NoContent(http.StatusOK) }
func (m *MockRecipeController) GetRecipeById(c echo.Context) error { return c.NoContent(http.StatusOK) }
func (m *MockRecipeController) FavoriteRecipe(c echo.Context) error {
	return c.NoContent(http.StatusOK)
}
func (m *MockRecipeController) UnFavoriteRecipe(c echo.Context) error {
	return c.NoContent(http.StatusOK)
}

func setupTestRouter() *echo.Echo {
	uc := &MockUserController{}
	rc := &MockRecipeController{}
	return NewRouter(uc, rc)
}

func TestRouterRoutes(t *testing.T) {
	e := setupTestRouter()

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

func TestCORSConfig(t *testing.T) {
	os.Setenv("FE_URL", "http://localhost:3000")
	e := setupTestRouter()

	req := httptest.NewRequest(http.MethodOptions, "/signup", nil)
	req.Header.Set(echo.HeaderOrigin, "http://localhost:3000")
	req.Header.Set(echo.HeaderAccessControlRequestMethod, http.MethodPost)

	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	assert.Equal(t, http.StatusNoContent, rec.Code, "CORS の設定が正しく動作しているか")
	assert.Equal(t, "http://localhost:3000", rec.Header().Get("Access-Control-Allow-Origin"))
}
