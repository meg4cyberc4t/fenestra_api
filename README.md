# notify-api

## Information for developers

## Steps for launch

- make build (Start postgres database on port 5432)
- make migrate_up (Apply migrations)
- dart run bin/main.dart (Start server on port 8080)

### Also important
- make migration_down (Discard migrations)

## P.s.

- bash script "wait-for-postgres.sh" can help when absolutely the entire application system will be launched from the docker. I currently have a server running separately, but that doesn't mean I won't want to do everything in one big docker in the future))