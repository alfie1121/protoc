# protoc
編譯 protobuf 工具，指定特定版本。

```
需要安裝 docker
```

## 建立映像檔
```
docker build --rm -t protoexec .
```

在 proto 專案加上
```
	docker run --rm -v $(shell pwd):/mnt protoexec  \
	--go_out=plugins=grpc:./ \
	--govalidators_out=./ \ <- 如有使用 validators 需加上
	--proto_path=./ \
	--proto_path=./vendor \ <- 如有使用 validators 需加上
	./proto/*.proto
```

## 鎖定版號
```
protoc-gen-go@v1.5.2
protoc-gen-govalidators@v0.3.2
```

## 使用 go mod 的話
1. 先建一個檔案塞入需要的 import，例如
```
init.go

import (
	_ "github.com/mwitkow/go-proto-validators"

	_ "google.golang.org/protobuf/reflect/protoreflect"
	_ "google.golang.org/protobuf/runtime/protoimpl"
)
```
服務在下載依賴時才可以編譯

2. 執行 go mod tidy
3. go mod vendor
4. protoexec 要 mnt 上當前的專案
