FROM golang:1.21 AS build
WORKDIR /app
COPY go.mod .
COPY main.go .
RUN go build -o service .

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /app/service /app/service
EXPOSE 8093
ENTRYPOINT ["/app/service"]
