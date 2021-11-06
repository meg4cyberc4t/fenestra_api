import 'dart:convert';

import '../repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class ListsHandlers {
  ListsHandlers(this.repos, this.defaultHeaders);
  final Repository repos;
  final Map<String, String> defaultHeaders;

  Router get router {
    final router = Router();
    router.get('/getLists', (Request request) async {
      print(request.context);
      return Response.ok(jsonEncode({"Json": "пнх", "Мда": "Why?"}));
    });

    return router;
  }
}
