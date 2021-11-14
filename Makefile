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

test:
	cd ..
	cd mega_api
	migrate -path schema/ -database "postgres://postgres:SUPERPASSWORD@localhost:5432/postgres?sslmode=disable" down --all;
	migrate -path schema/ -database "postgres://postgres:SUPERPASSWORD@localhost:5432/postgres?sslmode=disable" up;
	echo "------------------";
	clear;
	cd ..
	cd megasdkdart
	dart run test/megasdkdart_test.dart --chain-stack-traces;

