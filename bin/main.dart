import 'dart:io';
import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'configs/config.dart';
import 'handlers/listshandlers.dart';
import 'handlers/middleware.dart';
import 'handlers/authhandlers.dart';
import 'repository/repository.dart';

class Service {
  Service(this.repos);
  final Repository repos;

  Handler get handlers {
    final router = Router();
    Map<String, String> defaultHeaders = {"Content-Type": 'application/json'};

    router.mount(
        '/auth/',
        Pipeline()
            .addMiddleware(createMiddleware(
              responseHandler: (Response response) =>
                  response.change(headers: defaultHeaders),
            ))
            .addMiddleware(handleErrors())
            .addHandler(AuthHandlers(repos, defaultHeaders).router));

    router.mount(
        '/lists/',
        Pipeline()
            .addMiddleware(createMiddleware(
              responseHandler: (Response response) =>
                  response.change(headers: defaultHeaders),
            ))
            .addMiddleware(handleErrors())
            .addMiddleware(handleAuth(secretServerKey))
            .addHandler(ListsHandlers(repos, defaultHeaders).router));

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );
    return router;
  }
}

void main() async {
  PostgreSqlExecutorPool executor =
      PostgreSqlExecutorPool(Platform.numberOfProcessors, () {
    return PostgreSQLConnection(
      'localhost',
      5432,
      'postgres',
      username: 'postgres',
      password: 'SUPERPASSWORD',
      useSSL: false,
    );
  });

  Repository repos = Repository(executor);
  Service service = Service(repos);
  final server = await shelf_io.serve(service.handlers, 'localhost', 8080);
  print('Server running on ${server.address}:${server.port}');
}
