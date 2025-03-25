package config

import (
	"context"
	"os"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
)

func LoadDefaultConfig(ctx context.Context) (aws.Config, error) {
	customResolver := aws.EndpointResolverWithOptionsFunc(func(service, region string, _ ...interface{}) (aws.Endpoint, error) {
		return aws.Endpoint{
			URL:           os.Getenv("LOCALSTACK_HOST"),
			SigningRegion: os.Getenv("AWS_REGION"),
		}, nil
	})

	return config.LoadDefaultConfig(ctx,
		config.WithRegion(os.Getenv("AWS_REGION")),
		config.WithEndpointResolverWithOptions(customResolver),
	)
}
