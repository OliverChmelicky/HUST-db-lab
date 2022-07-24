FROM golang:1.18-alpine

WORKDIR /build

COPY backend/ ./
RUN go mod download

RUN go build -o /app

EXPOSE 8080

RUN chmod 777 /app
ENTRYPOINT [ "/app" ]