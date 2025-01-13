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
	loginIdRegex := regexp.MustCompile(`^[a-zA-Z0-9_]+$`)
	return validation.ValidateStruct(&user,
		validation.Field(
			&user.LoginId,
			validation.Required.Error("loginid is required"),
			validation.RuneLength(1, 30).Error("limited max 30 char"),
			validation.Match(loginIdRegex).Error("is not valid loginid format"),
		),
		validation.Field(
			&user.Password,
			validation.Required.Error("password is required"),
			validation.RuneLength(6, 30).Error("limited min 6 max 30 char"),
		),
	)
}
