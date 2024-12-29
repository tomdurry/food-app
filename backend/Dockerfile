FROM golang:1.23-bullseye

WORKDIR /app
ADD ./ ./

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

RUN apt update && apt install -y ca-certificates netcat postgresql-client

EXPOSE 8080

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]
