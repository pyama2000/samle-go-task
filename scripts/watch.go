package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
)

func killChild() {
	_ = exec.Command(
		"sh",
		"-c",
		"kill $(ps alx | awk \"\\$3 == $(cat watch.pid) {print \\$2}\")",
	).Run()
}

func main() {
	killChild()

	cmd := exec.Command("go", "run", "cmd/server/main.go")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Start(); err != nil {
		panic(err)
	}

	pid := cmd.Process.Pid

	fmt.Println(pid)

	if err := ioutil.WriteFile("watch.pid", []byte(strconv.Itoa(pid)), 0o666); err != nil {
		panic(err)
	}

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Printf("internal system error: %v", r)
			}
		}()

		for sig := range c {
			if sig == os.Interrupt {
				killChild()
				if err := os.Remove("watch.pid"); err != nil {
					panic(err)
				}
				close(c)
				os.Exit(3)
			}
		}
	}()

	if err := cmd.Wait(); err != nil {
		panic(err)
	}

	if err := os.Remove("watch.pid"); err != nil {
		panic(err)
	}
}
