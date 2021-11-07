import 'dart:convert';

import '../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../structs/list.dart';

class ListsHandlers {
  ListsHandlers(this.repos, this.defaultHeaders);
  final Repository repos;
  final Map<String, String> defaultHeaders;

  Router get router {
    final router = Router();
    router.post('/', (Request request) async {
      late NotificationList list;
      dynamic input = jsonDecode(await request.readAsString());
      list = NotificationList.fromParametersWithJson(
        json: input,
        id: -1,
        ownerId: request.context['id'] as int,
        moderatorIds: [request.context['id'] as int],
        subscribersIds: [request.context['id'] as int],
      );
      await repos.createNotificationListByList(list);
      return Response.ok({'id': list.id});
    });

    router.get('/', (Request request) async {
      var lists = await repos.getListsByUserId(request.context['id'] as int);
      List out = [];
      for (NotificationList item in lists) {
        out.add(item.toMap());
      }
      return Response.ok(jsonEncode(out));
    });

    router.delete('/<id>', (Request request, String id) async {
      late int listid;
      listid = int.parse(id);
      if (!await repos.getCheckRight(request.context['id'] as int, listid)) {
        throw "Not access to $listid notification list";
      }
      if (!await repos.deleteNotificationListById(
          listid, request.context['id'] as int)) {
        return Response.notFound('List not found');
      }
      return Response(204);
    });

    router.patch('/<id>', (Request request, String id) async {
      int listid = int.parse(id);
      dynamic input = jsonDecode(await request.readAsString());
      if (!await repos.getCheckRight(request.context['id'] as int, listid)) {
        throw "Not access to $listid notification list";
      }
      input
        ..remove('id')
        ..remove('owner_id')
        ..remove('moderator_ids')
        ..remove('subscribers_ids');
      NotificationList oldList = await repos.getListByListId(listid);
      NotificationList list = NotificationList.fromJsonWithParameters(
        json: input,
        id: listid,
        ownerId: oldList.ownerId,
        moderatorIds: oldList.moderatorIds,
        subscribersIds: oldList.subscribersIds,
        description: oldList.description,
        public: oldList.public,
        title: oldList.title,
      );
      await repos.editNotificationListByList(list);
      return Response.ok(jsonEncode(list.toMap()));
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('Resource not found'),
    );

    return router;
  }
}
