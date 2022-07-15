package main

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-pg/pg/extra/pgdebug"
	"github.com/go-pg/pg/v10"
	"project/access"
)

func main() {
	db := pg.Connect(&pg.Options{
		Addr:     "db-svc:5432",
		User:     "backend",
		Password: "backend",
		Database: "goo",
	})
	db.AddQueryHook(pgdebug.DebugHook{
		// Print all queries.
		Verbose: true,
	})

	if err := db.Ping(context.Background()); err != nil {
		fmt.Println("PostgreSQL is down", err)
		return
	}

	userAccess := access.DbAccess{Db: db}

	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		response, code, _ := userAccess.Test()
		c.JSON(code, gin.H{"user": response})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
