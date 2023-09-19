
migrate_install:
	curl -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz
	sudo mv migrate.linux-amd64 /usr/bin/migrate
	which migrate
	migrate -version

migrate_create:
	migrate create -ext sql -dir db/migration -seq ${migrate_name}

migrate_up:
	migrate -path ./migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrate_up_n:
	migrate -path ./migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up ${n}

migrate_down:
	migrate -path ./migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migrate_down_n:
	migrate -path ./migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down ${n}

mock_install:
	go install github.com/golang/mock/mockgen@v1.6.0

mock:
	mockgen -package mockdb -destination ./mock/store.go github.com/techschool/simplebank/db/sqlc Store

.PHONY: migrate_install migrate_create migrate_up migrate_up_n migrate_down migrate_down_n mock_install mock