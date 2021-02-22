package main

import (
	"fmt"
	"context"
	"testing"
  "flag"

	proto "code/ch01_02/greeter"
	"github.com/micro/go-micro/v2"
)

func init() {
	testing.Init() // add this line
	// flag.BoolVar(&debug, "debug", false, "enable debug logging")
	flag.Parse()
}

func TestCh0GreetingMicroservice(t *testing.T) {
	service := micro.NewService(micro.Name("greeter.client"))
	service.Init()
	greeter := proto.NewGreeterService("greeter", service.Client())

	rsp, err := greeter.Hello(context.TODO(), &proto.Request{Name: "test"})
	if err != nil {
		fmt.Println(err)
		return
	}

	if rsp.Greeting != "Hello, test! I'm glad to meet you!" {
		t.Errorf("Greet is not correct : %s", rsp.Greeting)
	}
	t.Log("Success")
}
