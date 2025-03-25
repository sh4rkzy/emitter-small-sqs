<h1 align="left">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Go_gopher_favicon.svg/2048px-Go_gopher_favicon.svg.png" alt="Go Gopher" width="30" />
  go-sqs-api
</h1>

API escrita em Go utilizando arquitetura hexagonal, responsável por enviar eventos e publicá-los em uma fila **SQS FIFO**.

---

## 📦 Tecnologias Utilizadas

- [Go](https://golang.org/) + Gin (API REST)
- AWS SDK v2 para Go (integração com SQS)
- [Terraform](https://www.terraform.io/) (infraestrutura como código)
- [LocalStack](https://localstack.cloud/) (emulador local da AWS)
- MongoDB (futuro uso para persistência, opcional)

---

## ⚙️ Execução Local

### 1. Requisitos

- Go >= 1.20
- Terraform >= 1.3
- LocalStack rodando localmente (`docker-compose up -d`)
- Docker (para LocalStack)

### 2. Clonar o projeto

```bash
git clone https://github.com/sh4rkzy/emitter-small-sqs.git
cd go-tracking-api
```

### 3. Criar o arquivo `.env`

```env
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
PORT=8080
```

> Dica: use o `example.env` se estiver disponível.

### 4. Rodar a API

```bash
go run cmd/api/main.go
```

A API ficará disponível em: [http://localhost:8080/event](http://localhost:8080/event)

---

## 📨 Endpoint

### POST `/event`

Envia um evento para a fila SQS.

#### Exemplo de requisição

```bash
curl -X POST http://localhost:8080/event \
  -H "Content-Type: application/json" \
  -d '{"message": "Entrega 123 saiu para entrega"}'
```

#### Payload

```json
{
  "message": "string"
}
```

---

## ☁️ Infraestrutura com Terraform (LocalStack)

A infraestrutura (SQS FIFO + IAM user + DLQ) está localizada em:

```
terraform/
└── development/
    ├── sqs.tf
    ├── iam.tf
    ├── provider.tf
    ├── variables.tf
    ├── outputs.tf
```

### Comandos via Makefile

```bash
# Inicializa o Terraform
make infra-init

# Mostra o plano de criação
make infra-plan

# Aplica a infraestrutura local (fila + DLQ + IAM)
make infra-up

# Destroi os recursos
make infra-destroy
```

> Os comandos usam as variáveis do `.env` automaticamente.

---

## 🧱 Estrutura do Projeto

```bash
go-tracking-api/
├── cmd/                     # Entrypoint da aplicação
│   └── api/
│       └── main.go
├── internal/
│   ├── application/         # Casos de uso
│   ├── domain/              # Portas e entidades
│   ├── infrastructure/      # Adapters (SQS, Mongo, etc.)
│   └── interfaces/          # HTTP handlers
├── config/                  # Configuração AWS + .env
├── terraform/               # Infraestrutura como código
│   └── development/
├── Makefile
├── .env
├── go.mod
└── README.md
```

---

## 📌 Observações

- Esta API simula o ambiente AWS usando **LocalStack**.
- Em produção, basta trocar os endpoints e credenciais.
- Toda a lógica de envio de eventos está isolada em um caso de uso (`SendEventUseCase`).

---

## 📬 Contribuindo

Pull requests são bem-vindos! Para mudanças maiores, abra uma issue primeiro para discutirmos o que você gostaria de alterar.

---

## 📄 Licença

Este projeto é open-source e licenciado sob a [MIT License](LICENSE).
