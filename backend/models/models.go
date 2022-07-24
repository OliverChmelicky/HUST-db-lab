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

type UserCreate struct {
	bun.BaseModel `bun:"table:Users,alias:u"`
	Name          string
	Password      string
	Phonenum      string
	Address       string
}
