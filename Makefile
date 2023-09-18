postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

create-db:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

drop-db:
	docker exec -it postgres12 dropdb simple_bank

docker-rm:
	@docker stop postgres12
	@docker rm postgres12

test:
	go clean -cache
	go test -v -cover ./...

server:
	go run main.go

.PHONY: postgres createdb docker-rm test server