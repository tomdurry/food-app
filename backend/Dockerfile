FROM golang:1.23-alpine

WORKDIR /app
ADD ./ ./

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

RUN apk --no-cache update && apk add --no-cache \
    ca-certificates \
    netcat-openbsd \
    postgresql-client

EXPOSE 8080

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]
