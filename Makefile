build:
	dart pub get
	docker-compose build
	docker-compose up

migrate_up:
	migrate -path schema/ -database "postgres://postgres:SUPERPASSWORD@localhost:5432/postgres?sslmode=disable" up

migrate_down:
	migrate -path schema/ -database "postgres://postgres:SUPERPASSWORD@localhost:5432/postgres?sslmode=disable" down

log: 
	git log --pretty=format:'%h %Cgreen %cr %Creset %aN %Cred %s %Creset |'

