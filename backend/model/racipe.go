package model

import (
	"encoding/json"
	"time"
)

type Ingredient struct {
	Ingredient string `json:"ingredient"`
	Quantity   string `json:"quantity"`
}

type Recipe struct {
	ID           uint            `json:"id" gorm:"primaryKey"`
	RecipeName   string          `json:"recipe_name" gorm:"not null"`
	Ingredients  json.RawMessage `json:"ingredients" gorm:"type:json"`
	Instructions json.RawMessage `json:"instructions" gorm:"type:json"`
	ImageUrl     string          `json:"image_url"`
	CreatedAt    time.Time       `json:"created_at"`
	UpdatedAt    time.Time       `json:"updated_at"`
	User         User            `json:"user" gorm:"foreignKey:UserId; constraint:OnDelete:CASCADE"`
	UserId       uint            `json:"user_id" gorm:"not null"`
}

type RecipeResponse struct {
	ID           uint            `json:"id" gorm:"primaryKey"`
	RecipeName   string          `json:"recipe_name"`
	Ingredients  json.RawMessage `json:"ingredients"`
	Instructions json.RawMessage `json:"instructions"`
	ImageUrl     string          `json:"image_url"`
	CreatedAt    time.Time       `json:"created_at"`
	UpdatedAt    time.Time       `json:"updated_at"`
}
