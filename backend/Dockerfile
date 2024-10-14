FROM golang:1.23-bullseye as builder

WORKDIR /app
ADD ./ ./

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

FROM debian:10-slim
RUN apt update && apt install -y ca-certificates

COPY --from=builder /app/main /app/main
EXPOSE 8080

ENTRYPOINT [ "/app/main" ]