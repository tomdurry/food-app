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
			validation.Required.Error("ログインIDは必須です"),
			validation.RuneLength(1, 16).Error("ログインIDは最大16文字です"),
			validation.Match(loginIdRegex).Error("ログインIDは英数字とアンダースコア (_) のみ使用可能です"),
		),
		validation.Field(
			&user.Password,
			validation.Required.Error("パスワードは必須です"),
			validation.RuneLength(6, 30).Error("パスワードは6文字から30文字で設定してください"),
		),
	)
}
