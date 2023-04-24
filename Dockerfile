FROM  golang:1.16.12-alpine

ENV GLIBC_VERSION=2.33-r0
RUN apk --no-cache add wget git \
    && wget -q https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O glibc.apk \
    && apk add glibc.apk \
    && rm /etc/apk/keys/sgerrand.rsa.pub glibc.apk

RUN wget -q https://github.com/protocolbuffers/protobuf/releases/download/v3.19.0/protoc-3.19.0-linux-x86_64.zip -O protoc.zip \
    && unzip protoc.zip -d /usr/local \
    && rm protoc.zip \
    && apk del wget

ENV PATH="$PATH:$(go env GOPATH)/bin"

RUN go install github.com/golang/protobuf/protoc-gen-go@v1.5.2
RUN go install github.com/mwitkow/go-proto-validators/protoc-gen-govalidators@v0.3.2

VOLUME /mnt
WORKDIR /mnt

ENTRYPOINT ["protoc", "-I=/usr/local/include"]
