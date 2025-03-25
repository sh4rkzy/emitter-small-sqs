package domain

type Event struct {
	Message string `json:"message"`
}

type EventSenderPort interface {
	SendEvent(event Event) error
}