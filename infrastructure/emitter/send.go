package emitter

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/sh4rkzy/go-tracking-api/domain"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/aws"
)

type SQSSender struct {
	Client *sqs.Client
	QueuURL string
}

func NewSQSSender(client *sqs.Client, queueURL string) SQSSender {
	return SQSSender{Client: client, QueuURL: queueURL}
}

func (s SQSSender) SendEvent(event domain.Event) error {
	eventBytes, err := json.Marshal(event)
	if err != nil {
		return err
	}

	_, err = s.Client.SendMessage(context.TODO(), &sqs.SendMessageInput{
		MessageBody: aws.String(string(eventBytes)),
		QueueUrl:    aws.String(s.QueuURL),
	})
	if err != nil {
		return err
	}

	fmt.Println("Event sent to SQS" + string(eventBytes))
	return nil
}



