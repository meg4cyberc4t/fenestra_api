import 'dart:convert';

import '../../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../../structs/notify/folder.dart';
import '../../structs/notify/notification.dart';
import '../../structs/user.dart';

class NotificationsHandlers {
  const NotificationsHandlers(this.repos);
  final Repository repos;

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      List<NotificationStruct> data =
          await repos.notify.notifications.get(selectUser);
      return Response.ok(jsonEncode(data.map((e) => e.toMap()).toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      int notificationId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      NotificationStruct data =
          await repos.notify.notifications.getById(selectUser, notificationId);
      return Response.ok(jsonEncode(data.toMap()));
    });

    router.get('/byFolder/<id>', (Request request, String id) async {
      int folderid = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct folder =
          await repos.notify.folders.getById(selectUser, folderid);
      List<NotificationStruct> data =
          await repos.notify.notifications.getByFolder(folder);
      return Response.ok(jsonEncode(data.map((e) => e.toMap()).toList()));
    });

    router.post('/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      NotificationStruct notification = NotificationStruct(
        title: input['title'],
        description: input['description'],
        owner: request.context['id'] as int,
        deadline: input['deadline'],
        repeat: input['repeat'],
        folder: input['folder'],
        invited: input['invited'] ?? [],
        id: null,
      );
      await repos.notify.notifications.add(notification);
      return Response.ok(jsonEncode({"id": notification.id}));
    });

    router.delete('/<id>', (Request request, String id) async {
      int notificationId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct selectNotification =
          await repos.notify.folders.getById(selectUser, notificationId);
      await repos.notify.folders.delete(selectUser, selectNotification);
      return Response(201);
    });

    router.patch('/<id>', (Request request, String id) async {
      int notificationId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      NotificationStruct selectNotification =
          await repos.notify.notifications.getById(selectUser, notificationId);
      dynamic input = jsonDecode(await request.readAsString());

      if (input['title'] != null) {
        selectNotification.title = input['title'];
      }
      if (input['description'] != null) {
        selectNotification.description = input['description'];
      }
      if (input['deadline'] != null) {
        selectNotification.deadline = input['deadline'];
      }
      if (input['repeat'] != null) {
        selectNotification.repeat = input['repeat'];
      }
      if (input['folder'] != null) {
        selectNotification.folder =
            (await repos.notify.folders.getById(selectUser, input['folder']))
                .id;
      }
      await repos.notify.notifications.edit(selectUser, selectNotification);
      return Response.ok(jsonEncode(selectNotification.toMap()));
    });

    router.post('/<id>/invite', (Request request, String id) async {
      int notificationId = int.parse(id);
      UserStruct ownerUser =
          await repos.users.getFromId(request.context['id'] as int);
      NotificationStruct selectNotification =
          await repos.notify.notifications.getById(ownerUser, notificationId);
      dynamic input = jsonDecode(await request.readAsString());
      UserStruct inviteUser = await repos.users.getFromId(input['id']);
      if (!selectNotification.invited.contains(inviteUser.id)) {
        await repos.notify.notifications.invite(selectNotification, inviteUser);
      }

      return Response(201);
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(''),
    );

    return router;
  }
}
