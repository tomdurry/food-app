package repository

import (
	"github.com/tomdurry/food-app/model"

	"gorm.io/gorm"
)

type IUserRepository interface {
	GetUserByUserID(user *model.User, user_id string) error
	CreateUser(user *model.User) error
}

type userRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) IUserRepository {
	return &userRepository{db}
}

func (ur *userRepository) GetUserByUserID(user *model.User, user_id string) error {
	if err := ur.db.Where("user_id=?", user_id).First(user).Error; err != nil {
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
