package models

type User struct {
	tableName struct{} `pg:"Users"`
	Uid       int
	Name      string
	Password  string
	Phonenum  string
	Address   string
}
