package models

import "github.com/uptrace/bun"

type User struct {
	bun.BaseModel `bun:"table:Users,alias:u"`
	Id            int
	Name          string
	Password      string
	Phonenum      string
	Address       string
}
