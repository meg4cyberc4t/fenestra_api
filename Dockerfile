FROM dart:stable

COPY ./ ./

# install psql
RUN apt-get update
RUN apt-get -y install postgresql-client

# make wait-for-postgres.sh executable
RUN chmod +x wait-for-postgres.sh

# build go app
RUN dart pub get
RUN dart compile exe ./bin/main.dart

CMD ["./bin/main.exe"]