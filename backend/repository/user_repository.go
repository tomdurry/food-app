package repository

import (
	"github.com/tomdurry/food-app/model"

	"gorm.io/gorm"
)

type IUserRepository interface {
	GetUserByLoginId(user *model.User, login_id string) error
	CreateUser(user *model.User) error
}

type userRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) IUserRepository {
	return &userRepository{db}
}

func (ur *userRepository) GetUserByLoginId(user *model.User, login_id string) error {
	if err := ur.db.Where("login_id=?", login_id).First(user).Error; err != nil {
		return err
	}
	return nil
}

func (ur *userRepository) CreateUser(user *model.User) error {
	if err := ur.db.Create(user).Error; err != nil {
		return err
	}
	return nil
}
