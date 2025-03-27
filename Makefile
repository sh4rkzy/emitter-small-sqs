-include .env

TERRAFORM_DIR=terraform/development
BUILD_DIR=bin
APP_NAME=go-sqs-api
ENTRYPOINT=cmd/api/main.go
DOCKER_IMAGE=go-sqs-api
DOCKER_PORT=80

# ==== Verifica se .env existe ====

check-env:
	@if [ ! -f .env ]; then \
		echo "⚠️  .env file not found. Running 'make init'..."; \
		$(MAKE) init; \
	fi

# ==== Initialize ====

init:
	@echo "🚀 Initializing local development environment..."
	@cp .env.example .env
	@echo "✅ .env file created from .env.example."
	@echo "🔧 Installing Go dependencies..."
	go mod download
	@echo "🔧 Initializing Terraform..."
	$(MAKE) infra-init
	@echo "✅ Init complete!"
	@echo "🔧 Run 'make infra-up' to create the infrastructure."

# ==== Terraform ====

infra-init:
	terraform -chdir=$(TERRAFORM_DIR) init

infra-plan: check-env
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) plan

infra-up: check-env
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) apply -auto-approve

infra-destroy: check-env
	TF_VAR_aws_region=$(AWS_REGION) \
	TF_VAR_aws_access_key=$(AWS_ACCESS_KEY_ID) \
	TF_VAR_aws_secret_key=$(AWS_SECRET_ACCESS_KEY) \
	terraform -chdir=$(TERRAFORM_DIR) destroy -auto-approve

# ==== Go Build ====

build: check-env
	@echo "🔧 Building application..."
	@mkdir -p $(BUILD_DIR)
	go mod tidy
	GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(APP_NAME) $(ENTRYPOINT)
	@echo "✅ Build complete → $(BUILD_DIR)/$(APP_NAME)"

run: check-env
	@echo "🚀 Running app locally on :$(PORT)"
	go run $(ENTRYPOINT)

clean:
	@echo "🧹 Cleaning build and Docker artifacts..."
	@rm -rf $(BUILD_DIR)
	@docker rmi -f $(DOCKER_IMAGE) 2>/dev/null || true

# ==== Docker ====

docker-build: check-env
	@echo "🐳 Building Docker image..."
	docker build -t $(DOCKER_IMAGE) .

docker-run: check-env
	@echo "🐳 Running container on port $(DOCKER_PORT)..."
	docker run -p $(DOCKER_PORT):80 $(DOCKER_IMAGE)

docker-rebuild: clean docker-build docker-run
