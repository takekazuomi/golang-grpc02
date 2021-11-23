// Package main implements a server for Greeter service.
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"

	pb "github.com/takekazuomi/golang-grpc01/helloworld"
	"google.golang.org/grpc"
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedGreeterServer
}

var (
	port = getEnv("PORT", "50051")
)

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	hostname, err := os.Hostname()

	if err != nil {
		log.Printf("Could not get hostname: %v", err)
		hostname = "unknown"
	}

	env := os.Environ()
	for i, v := range env {
		fmt.Printf("[%d] %v\n", i, v)
	}

	log.Printf("Received %v", in.Name)
	return &pb.HelloReply{Message: "Hello2 '" + in.Name + "' from " + hostname}, nil
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	log.Print(key + " env not set")
	return fallback
}

func main() {
	flag.Parse()

	lis, err := net.Listen("tcp", fmt.Sprintf(":%v", port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()

	pb.RegisterGreeterServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
