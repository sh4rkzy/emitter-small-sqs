package app

import "github.com/sh4rkzy/go-tracking-api/domain"


type SendEventUseCase struct {
	Sender domain.EventSenderPort
}

func NewSendEventUseCase(sender domain.EventSenderPort) SendEventUseCase {
	return SendEventUseCase{Sender: sender}
}

func (uc *SendEventUseCase) Execute(event domain.Event) error {
	return uc.Sender.SendEvent(event)
}