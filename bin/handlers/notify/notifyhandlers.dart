import '../../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'folderhandlers.dart';

class NotifyHandlers {
  const NotifyHandlers(this.repos);
  final Repository repos;

  Router get router {
    final router = Router();

    router.mount('/folders/', FolderHandlers(repos).router);

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(''),
    );

    return router;
  }
}
