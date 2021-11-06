import 'dart:convert';
import 'dart:developer';

import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../structs/error.dart';
import '../structs/list.dart';
import '../structs/reponse.dart';

class ListsHandlers {
  ListsHandlers(this.repos, this.defaultHeaders);
  final Repository repos;
  final Map<String, String> defaultHeaders;

  Router get router {
    final router = Router();
    router.post('/', (Request request) async {
      late NotificationList list;
      try {
        dynamic input = jsonDecode(await request.readAsString());
        list = NotificationList.fromJson(
          json: input,
          id: -1,
          ownerId: request.context['id'] as int,
          moderatorIds: [request.context['id'] as int],
          subscribersIds: [request.context['id'] as int],
        );
        await repos.createNotificationListByList(list);
      } catch (e) {
        log(e.toString());
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()));
      }
      return Response.ok(jsonEncode(ApiResponse('ok').toMap()));
    });

    router.get('/', (Request request) async {
      var lists = await repos.getListsByUserId(request.context['id'] as int);
      List out = [];
      for (NotificationList item in lists) {
        out.add(item.toMap());
      }
      return Response.ok(jsonEncode(ApiResponse(out).toMap()));
    });

    router.delete('/<id>', (Request request, String id) async {
      late int listid;
      try {
        listid = int.parse(id);
      } catch (e) {
        log(e.toString());
        return Response.ok(jsonEncode(ApiError.badArguments.toMap()));
      }
      if (!await repos.getCheckRight(request.context['id'] as int, listid)) {
        return Response.ok(jsonEncode(ApiError.accessDenied.toMap()));
      }
      if (!await repos.deleteNotificationListById(
          listid, request.context['id'] as int)) {
        return Response.ok(jsonEncode(ApiResponse(false).toMap()));
      }
      return Response.ok(jsonEncode(ApiResponse(true).toMap()));
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.ok(jsonEncode(ApiError.notFound.toMap())),
    );

    return router;
  }
}
