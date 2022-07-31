package main

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/driver/pgdriver"
	"github.com/uptrace/bun/extra/bundebug"
	"project/access"
)

func main() {
	dsn := "postgres://goo:goo@localhost:5432/goo?sslmode=disable"
	sqldb := sql.OpenDB(pgdriver.NewConnector(pgdriver.WithDSN(dsn)))

	db := bun.NewDB(sqldb, pgdialect.New())

	db.AddQueryHook(bundebug.NewQueryHook(
		bundebug.WithVerbose(true),
		bundebug.FromEnv("BUNDEBUG"),
	))

	_, err := db.ExecContext(context.Background(), "SELECT 1")
	if err != nil {
		fmt.Println(err)
		return
	}

	userAccess := access.DbAccess{Db: db}

	r := gin.Default()

	r.POST("/user", func(c *gin.Context) {
		userAccess.CreateUser(c)
	})
	r.GET("/user", func(c *gin.Context) {
		userAccess.GetUserById(c)
	})

	r.PUT("/user", func(c *gin.Context) {
		userAccess.UpdateUser(c)
	})

	err = r.Run("0.0.0.0:8081") // listen and serve on 0.0.0.0:8080
	if err != nil {
		fmt.Println(err)
	}
}
