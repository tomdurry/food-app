package controller_test

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"

	"github.com/tomdurry/food-app/controller"
	"github.com/tomdurry/food-app/model"
)

type MockUserUsecase struct {
	mock.Mock
}

func (m *MockUserUsecase) SignUp(user model.User) (model.UserResponse, error) {
	args := m.Called(user)
	return args.Get(0).(model.UserResponse), args.Error(1)
}

func (m *MockUserUsecase) Login(user model.User) (string, error) {
	args := m.Called(user)
	return args.String(0), args.Error(1)
}

func setupUserTestController() (controller.IUserController, *MockUserUsecase, *echo.Echo) {
	mockUsecase := new(MockUserUsecase)
	userController := controller.NewUserController(mockUsecase)
	e := echo.New()
	return userController, mockUsecase, e
}

func TestSignUp(t *testing.T) {
	controller, mockUsecase, e := setupUserTestController()
	mockUserRes := model.UserResponse{ID: 1, LoginId: "TestUser"}
	mockUsecase.On("SignUp", mock.Anything).Return(mockUserRes, nil)

	req := httptest.NewRequest(http.MethodPost, "/signup", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)

	if assert.NoError(t, controller.SignUp(c)) {
		assert.Equal(t, http.StatusCreated, res.Code)
	}
}

func TestLogIn(t *testing.T) {
	controller, mockUsecase, e := setupUserTestController()
	mockUsecase.On("Login", mock.Anything).Return("mockToken", nil)

	req := httptest.NewRequest(http.MethodPost, "/login", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)

	if assert.NoError(t, controller.LogIn(c)) {
		assert.Equal(t, http.StatusOK, res.Code)
	}
}

func TestLogOut(t *testing.T) {
	controller, _, e := setupUserTestController()

	req := httptest.NewRequest(http.MethodPost, "/logout", nil)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)

	if assert.NoError(t, controller.LogOut(c)) {
		assert.Equal(t, http.StatusOK, res.Code)
	}
}

func TestCsrfToken(t *testing.T) {
	controller, _, e := setupUserTestController()

	req := httptest.NewRequest(http.MethodGet, "/csrf-token", nil)
	res := httptest.NewRecorder()
	c := e.NewContext(req, res)
	c.Set("csrf", "mockCsrfToken")

	if assert.NoError(t, controller.CsrfToken(c)) {
		assert.Equal(t, http.StatusOK, res.Code)
		var response map[string]string
		json.Unmarshal(res.Body.Bytes(), &response)
		assert.Equal(t, "mockCsrfToken", response["csrf_token"])
	}
}
