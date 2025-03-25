package http

import (

	"net/http"
	"github.com/sh4rkzy/go-tracking-api/app"
	"github.com/sh4rkzy/go-tracking-api/domain"
	"github.com/gin-gonic/gin"
)

type EventHandler struct {
	UseCase *app.SendEventUseCase
}

func NewEventHandler(useCase *app.SendEventUseCase) *EventHandler {
	return &EventHandler{UseCase: useCase}
}

func (h *EventHandler) RegisterRoutes(r *gin.Engine) {
	r.POST("/event", h.sendEvent)
}

func (h *EventHandler) sendEvent(c *gin.Context) {
	var event domain.Event
	if err := c.ShouldBindJSON(&event); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid payload"})
		return
	}

	err := h.UseCase.Execute(event)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "sent"})
}
