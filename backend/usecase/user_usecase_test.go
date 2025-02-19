package usecase_test

import (
	"os"
	"testing"

	"github.com/golang-jwt/jwt/v4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"golang.org/x/crypto/bcrypt"

	"github.com/tomdurry/food-app/model"
	"github.com/tomdurry/food-app/usecase"
)

type MockUserRepository struct {
	mock.Mock
}

type MockUserValidator struct {
	mock.Mock
}

func (m *MockUserRepository) CreateUser(user *model.User) error {
	args := m.Called(user)
	return args.Error(0)
}

func (m *MockUserRepository) GetUserByLoginId(user *model.User, loginId string) error {
	args := m.Called(user, loginId)
	return args.Error(0)
}

func (m *MockUserValidator) UserValidate(user model.User) error {
	args := m.Called(user)
	return args.Error(0)
}

func TestSignUp(t *testing.T) {
	repo := new(MockUserRepository)
	validator := new(MockUserValidator)
	uc := usecase.NewUserUsecase(repo, validator)

	user := model.User{LoginId: "testuser", Password: "password123"}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(user.Password), 10)

	validator.On("UserValidate", user).Return(nil)
	repo.On("CreateUser", mock.Anything).Return(nil).Run(func(args mock.Arguments) {
		arg := args.Get(0).(*model.User)
		arg.ID = 1
		arg.Password = string(hashedPassword)
	})

	res, err := uc.SignUp(user)
	assert.NoError(t, err)
	assert.Equal(t, "testuser", res.LoginId)
}

func TestLogin(t *testing.T) {
	repo := new(MockUserRepository)
	validator := new(MockUserValidator)
	uc := usecase.NewUserUsecase(repo, validator)

	user := model.User{LoginId: "testuser", Password: "password123"}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(user.Password), 10)
	storedUser := model.User{ID: 1, LoginId: "testuser", Password: string(hashedPassword)}

	validator.On("UserValidate", user).Return(nil)
	repo.On("GetUserByLoginId", mock.Anything, "testuser").Return(nil).Run(func(args mock.Arguments) {
		arg := args.Get(0).(*model.User)
		*arg = storedUser
	})

	os.Setenv("SECRET", "testsecret")
	token, err := uc.Login(user)
	assert.NoError(t, err)
	assert.NotEmpty(t, token)

	parsedToken, _ := jwt.Parse(token, func(token *jwt.Token) (interface{}, error) {
		return []byte("testsecret"), nil
	})
	assert.NotNil(t, parsedToken)
}

func TestLogin_InvalidPassword(t *testing.T) {
	repo := new(MockUserRepository)
	validator := new(MockUserValidator)
	uc := usecase.NewUserUsecase(repo, validator)

	user := model.User{LoginId: "testuser", Password: "wrongpassword"}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("password123"), 10)
	storedUser := model.User{ID: 1, LoginId: "testuser", Password: string(hashedPassword)}

	validator.On("UserValidate", user).Return(nil)
	repo.On("GetUserByLoginId", mock.Anything, "testuser").Return(nil).Run(func(args mock.Arguments) {
		arg := args.Get(0).(*model.User)
		*arg = storedUser
	})

	token, err := uc.Login(user)
	assert.Error(t, err)
	assert.Empty(t, token)
}
