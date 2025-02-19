package repository

import (
	"regexp"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/stretchr/testify/assert"
	"github.com/tomdurry/food-app/model"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func setupTestDB() (*gorm.DB, sqlmock.Sqlmock, error) {
	sqlDB, mock, err := sqlmock.New()
	if err != nil {
		return nil, nil, err
	}
	db, err := gorm.Open(postgres.New(postgres.Config{
		Conn: sqlDB,
	}), &gorm.Config{})
	if err != nil {
		return nil, nil, err
	}

	return db, mock, nil
}

func TestGetUserByLoginId(t *testing.T) {
	db, mock, err := setupTestDB()
	assert.NoError(t, err)
	repo := NewUserRepository(db)

	loginID := "testuser"
	expectedUser := &model.User{
		ID:        1,
		LoginId:   loginID,
		Password:  "hashedpassword",
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	rows := sqlmock.NewRows([]string{"id", "login_id", "password", "created_at", "updated_at"}).
		AddRow(expectedUser.ID, expectedUser.LoginId, expectedUser.Password, expectedUser.CreatedAt, expectedUser.UpdatedAt)

	mock.ExpectQuery(regexp.QuoteMeta("SELECT * FROM \"users\" WHERE login_id=$1 ORDER BY \"users\".\"id\" LIMIT $2")).
		WithArgs(loginID, 1).
		WillReturnRows(rows)

	var user model.User
	err = repo.GetUserByLoginId(&user, loginID)
	assert.NoError(t, err)
	assert.Equal(t, expectedUser.ID, user.ID)
	assert.Equal(t, expectedUser.LoginId, user.LoginId)
	assert.Equal(t, expectedUser.Password, user.Password)
}

func TestCreateUser(t *testing.T) {
	db, mock, err := setupTestDB()
	assert.NoError(t, err)
	repo := NewUserRepository(db)

	fixedTime := time.Now()

	newUser := &model.User{
		LoginId:   "newuser",
		Password:  "newhashedpassword",
		CreatedAt: fixedTime,
		UpdatedAt: fixedTime,
	}

	rows := sqlmock.NewRows([]string{"id"}).AddRow(1)

	mock.ExpectBegin()
	mock.ExpectQuery(regexp.QuoteMeta("INSERT INTO \"users\" (\"login_id\",\"password\",\"created_at\",\"updated_at\") VALUES ($1,$2,$3,$4) RETURNING \"id\"")).
		WithArgs(newUser.LoginId, newUser.Password, fixedTime, fixedTime).
		WillReturnRows(rows)
	mock.ExpectCommit()

	err = repo.CreateUser(newUser)
	assert.NoError(t, err)
	assert.Equal(t, uint(1), newUser.ID)
}
