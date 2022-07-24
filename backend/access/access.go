package access

import (
	"context"
	"fmt"
	"github.com/uptrace/bun"
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
