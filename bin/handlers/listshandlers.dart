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
        moderatorIds: <int>[],
        subscribersIds: <int>[],
      );
      await repos.lists.create(list);
      return Response(201);
    });

    router.get('/', (Request request) async {
      var lists = await repos.lists.getAll(request.context['id'] as int);
      return Response.ok(jsonEncode(lists.map((e) => e.toMap()).toList()));
    });

    router.delete('/<id>', (Request request, String id) async {
      await repos.lists.delete(int.parse(id), request.context['id'] as int);
      return Response(204);
    });

    router.patch('/<id>', (Request request, String id) async {
      int listid = int.parse(id);
      dynamic input = jsonDecode(await request.readAsString())
        ..remove('id')
        ..remove('owner_id')
        ..remove('moderator_ids')
        ..remove('subscribers_ids');
      NotificationList oldList =
          await repos.lists.getById(listid, request.context['id'] as int);
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
      await repos.lists.edit(list);
      return Response.ok(jsonEncode(list.toMap()));
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('Resource not found'),
    );

    return router;
  }
}
