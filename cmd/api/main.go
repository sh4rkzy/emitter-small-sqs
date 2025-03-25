package main

import (
	"context"
	"log"
	"os"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/gin-gonic/gin"
	"github.com/sh4rkzy/go-tracking-api/app"
	"github.com/sh4rkzy/go-tracking-api/infrastructure/emitter"
	"github.com/sh4rkzy/go-tracking-api/interfaces/http"
	"github.com/sh4rkzy/go-tracking-api/internal"
	_ "github.com/joho/godotenv/autoload"
)

func main() {
	ctx := context.Background()

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatalf("failed to load AWS config: %v", err)
	}

	sqsClient := sqs.NewFromConfig(cfg)
	queueURL := os.Getenv("SQS_URL")
	sender := emitter.NewSQSSender(sqsClient, queueURL)

	useCase := app.NewSendEventUseCase(sender)
	handler := http.NewEventHandler(&useCase)

	router := gin.Default()
	handler.RegisterRoutes(router)
	port := os.Getenv("PORT")
	log.Printf("API running on port %s 🚚", port)
	router.Run(":" + os.Getenv("PORT"))
}
