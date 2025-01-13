package validator

import (
	"regexp"

	"github.com/tomdurry/food-app/model"

	validation "github.com/go-ozzo/ozzo-validation/v4"
)

type IUserValidator interface {
	UserValidate(user model.User) error
}

type userValidator struct{}

func NewUserValidator() IUserValidator {
	return &userValidator{}
}

func (uv *userValidator) UserValidate(user model.User) error {
	userIDRegex := regexp.MustCompile(`^[a-zA-Z0-9_]+$`)
	return validation.ValidateStruct(&user,
		validation.Field(
			&user.UserID,
			validation.Required.Error("user_id is required"),
			validation.RuneLength(1, 30).Error("limited max 30 char"),
			validation.Match(userIDRegex).Error("is not valid user_id format"),
		),
		validation.Field(
			&user.Password,
			validation.Required.Error("password is required"),
			validation.RuneLength(6, 30).Error("limited min 6 max 30 char"),
		),
	)
}
