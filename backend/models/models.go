package models

import (
	"github.com/uptrace/bun"
	"time"
)

type User struct {
	bun.BaseModel `bun:"table:users,alias:u"`
	Id            int `bun:"id,pk,autoincrement"`
	Name          string
	Password      string
	Phonenum      string
	Address       string
}

type UserCreate struct {
	bun.BaseModel `bun:"table:users,alias:u"`
	Name          string
	Password      string
	Phonenum      string
	Address       string
}

type OrderStatus string

const (
	ToPay     OrderStatus = "ToPay"
	ToShip    OrderStatus = "ToShip"
	ToReceive OrderStatus = "ToReceive"
	Completed OrderStatus = "Completed"
	Cancel    OrderStatus = "Cancel"
)

type Order struct {
	Id              int
	UserId          int         // bigint NOT NULL REFERENCES "Users" ("id"),
	CreatedAt       time.Time   //timestamp NOT NULL DEFAULT 'now()',
	TotalPrice      int         //integer NOT NULL,
	Status          OrderStatus // cart_status NOT NULL DEFAULT 'ToPay',
	ShippingAddress string
	ShippingFee     int
	VoucherId       int
	PaymentInfo     string
}

//type ProductOrders struct {
//	"id" int,
//	"cart_id" bigint NOT NULL REFERENCES "Orders" ("id"),
//	"stock_id" bigint NOT NULL REFERENCES "ProductStocks" ("id"),
//	"quantity" integer NOT NULL
//}
