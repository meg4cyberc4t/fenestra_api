# mega_api

## Information for developers

### Steps for launch

- Create .env file and export the DB PASSWORD variable with the password from the database (By default it is included in .gitignore)
- Make build (Start postgres database on port 5432)
- Make migrate_up (Apply migrations)
- Dart run bin/main.dart (Start server on port 8080)

### Also important
- make migration_down (Discard migrations)
- make log (beautiful git log)

### You can also use the sdk to use the api in your projects
https://github.com/meg4cyberc4t/megasdkdart
