# tfupdate
FROM golang:1.13.3-alpine3.10 AS tfupdate
RUN apk --no-cache add make git
WORKDIR /work

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN make build

# hub
# The linux binary for hub can not run on alpine.
# So we need to build it from source.
# https://github.com/github/hub/issues/1818
FROM golang:1.13.3-alpine3.10 AS hub
RUN apk add --no-cache bash git
RUN git clone https://github.com/github/hub /work
WORKDIR /work
RUN ./script/build -o bin/hub

# runtime
FROM alpine:3.10
RUN apk --no-cache add git
COPY --from=tfupdate /work/bin/tfupdate /usr/local/bin/
COPY --from=hub /work/bin/hub /usr/local/bin/
ENTRYPOINT ["tfupdate"]