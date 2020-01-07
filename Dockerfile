FROM golang:1.13.0-alpine3.10 AS build-env

ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct
ENV BUILDPATH=github.com/eyebluecn/tank
RUN mkdir -p /go/src/${BUILDPATH}
COPY ./ /go/src/${BUILDPATH}
RUN cd /go/src/${BUILDPATH} && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install -v

FROM alpine:latest

COPY ./build /data/build
COPY --from=build-env /go/bin/tank /data/build/

WORKDIR /data
CMD ["/data/build/tank"]
