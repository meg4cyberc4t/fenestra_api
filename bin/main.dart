import 'package:postgres/postgres.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'extensions/dotnetmethods.dart';
import 'extensions/ymlmethods.dart';
import 'handlers/middleware.dart';
import 'handlers/authhandlers.dart';
import 'handlers/userhandlers.dart';
import 'repository/repository.dart';
import 'package:dotenv/dotenv.dart' show env;

class Service {
  const Service(this.repos, this.serverSecretKey);
  final Repository repos;
  final String serverSecretKey;

  Handler get handlers {
    final router = Router();

    router.mount(
        '/auth/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(AuthHandlers(repos, serverSecretKey).router));

    router.mount(
        '/user/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(UserHandlers(repos).router));

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );
    return router;
  }
}

void main() async {
  loadEnv();
  Map serverConfig = await loadYamlFile('bin/configs/config.yml');
  PostgreSQLConnection connection = PostgreSQLConnection(
    serverConfig['database']['host'],
    serverConfig['database']['port'],
    serverConfig['database']['databaseName'],
    username: serverConfig['database']['username'],
    password: env['DBPASSWORD'],
    useSSL: serverConfig['database']['useSSL'],
  );
  await connection.open();
  Repository repos = Repository(connection);
  Service service = Service(repos, serverConfig['server']['secretServerKey']);
  final server = await shelf_io.serve(
    service.handlers,
    serverConfig['server']['host'],
    serverConfig['server']['port'],
  );
  print('Server running on ${server.address}:${server.port}');
}
