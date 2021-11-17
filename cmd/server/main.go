package main

import (
	"net/http"

	"github.com/labstack/echo"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})
	e.GET("/go-task", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, go-task!")
	})
	e.Logger.Fatal(e.Start(":8080"))
}
