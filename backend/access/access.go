package access

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/uptrace/bun"
	"net/http"
	"project/models"
	"strconv"
)

type DbAccess struct {
	Db *bun.DB
}

func (DbAccess *DbAccess) CreateUser(c *gin.Context) {
	// Validate input
	var input models.UserCreate
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create user
	user := &models.UserCreate{Name: input.Name, Password: input.Password, Phonenum: input.Phonenum, Address: input.Address}

	res, err := DbAccess.Db.NewInsert().Model(user).Exec(context.Background())
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	fmt.Println(res)

	c.JSON(http.StatusOK, gin.H{"data": res})
}

func (DbAccess *DbAccess) GetUserById(c *gin.Context) {
	queryParams := c.Request.URL.Query()
	id, ok := queryParams["id"]
	if !ok {
		_ = c.AbortWithError(400, fmt.Errorf("you have to specify user id"))
	}

	intId, err := strconv.Atoi(id[0])
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := new(models.User)
	err = DbAccess.Db.NewSelect().Model(user).Where("id = ?", intId).Scan(context.Background())
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"user": user})
}

func (DbAccess *DbAccess) UpdateUser(c *gin.Context) {
	// Validate input
	input := new(models.User)
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	fmt.Println(input)

	_, err := DbAccess.Db.NewUpdate().Model(input).Where("id = ?", input.Id).Exec(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"user": input})
}
func (DbAccess *DbAccess) DeleteUser(c *gin.Context) {
	c.Writer.WriteHeader(http.StatusNotImplemented)
}

// TODO delete
