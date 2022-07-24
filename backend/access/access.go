package access

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/uptrace/bun"
	"net/http"
	"project/models"
)

type DbAccess struct {
	Db *bun.DB
}

func (DbAccess *DbAccess) Test() (models.User, int, error) {
	user := new(models.User)
	err := DbAccess.Db.NewSelect().Model(user).Where("id = ?", 1).Scan(context.Background())

	if err != nil {
		fmt.Println(err)
		return models.User{}, 500, err
	}
	return *user, 200, nil
}

func (DbAccess *DbAccess) CreateUser(c *gin.Context) {
	// Validate input
	var input models.UserCreate
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create book
	user := &models.UserCreate{Name: input.Name, Password: input.Password, Phonenum: input.Phonenum, Address: input.Address}

	res, err := DbAccess.Db.NewInsert().Model(user).Exec(context.Background())
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	fmt.Println(res)

	c.JSON(http.StatusOK, gin.H{"data": res})
}
