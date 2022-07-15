package access

import (
	"fmt"
	"github.com/go-pg/pg/v10"
	"project/models"
)

type DbAccess struct {
	Db *pg.DB
}

func (DbAccess *DbAccess) Test() (models.User, int, error) {
	user := new(models.User)
	err := DbAccess.Db.Model(user).Where("uid = ?", 1).Select()

	fmt.Println("User: ", user)
	if err != nil {
		fmt.Println(err)
		return models.User{}, 500, err
	}
	return *user, 200, nil
}
