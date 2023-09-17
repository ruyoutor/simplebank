postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

docker-rm:
	@docker stop postgres12
	@docker rm postgres12

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	docker run -u $(shell id -u):$(shell id -g) --rm -v "$(shell pwd):/src"  -w "/src" sqlc/sqlc generate

test:
	go clean -cache
	go test -v -cover ./...

server:
	go run main.go

mock_install:
	go install github.com/golang/mock/mockgen@v1.6.0

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store

.PHONY: postgres createdb migrateup migratedown docker-rm sqlc test server mock_install mock