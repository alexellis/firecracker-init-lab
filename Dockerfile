FROM golang:1.18-alpine as build

WORKDIR /go/src/github.com/alexellis/firecracker-init-lab/init

COPY init .

RUN go build --tags netgo --ldflags '-s -w -extldflags "-lm -lstdc++ -static"' -o init main.go

FROM alpine:3.15

COPY --from=build /go/src/github.com/alexellis/firecracker-init-lab/init/init /init

