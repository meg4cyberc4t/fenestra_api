import 'dart:convert';

import '../../repository/repository.dart';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../../structs/notify/folder.dart';
import '../../structs/user.dart';

class FolderHandlers {
  const FolderHandlers(this.repos);
  final Repository repos;

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      List<FolderStruct> data = await repos.notify.folders.get(selectUser);
      return Response.ok(jsonEncode(data.map((e) => e.toMap()).toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      int folderId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct data =
          await repos.notify.folders.getById(selectUser, folderId);
      return Response.ok(jsonEncode(data.toMap()));
    });

    router.post('/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      FolderStruct folder = FolderStruct(
          title: input['title'],
          description: input['description'],
          priority: input['priority'] ?? 0,
          id: null,
          owner: request.context['id'] as int);

      await repos.notify.folders.add(folder);
      return Response.ok(jsonEncode({"id": folder.id}));
    });

    router.delete('/<id>', (Request request, String id) async {
      int folderId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct selectFolder =
          await repos.notify.folders.getById(selectUser, folderId);
      await repos.notify.folders.delete(selectUser, selectFolder);
      return Response(201);
    });

    router.patch('/<id>', (Request request, String id) async {
      int folderId = int.parse(id);
      UserStruct selectUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct selectFolder =
          await repos.notify.folders.getById(selectUser, folderId);
      dynamic input = jsonDecode(await request.readAsString());
      if (input['title'] != null) {
        selectFolder.title = input['title'];
      }
      if (input['description'] != null) {
        selectFolder.description = input['description'];
      }
      if (input['priority'] != null) {
        selectFolder.priority = input['priority'];
      }
      await repos.notify.folders.edit(selectUser, selectFolder);
      return Response.ok(jsonEncode(selectFolder.toMap()));
    });

    router.post('/<id>/relation', (Request request, String id) async {
      int folderId = int.parse(id);
      UserStruct ownerUser =
          await repos.users.getFromId(request.context['id'] as int);
      FolderStruct selectFolder =
          await repos.notify.folders.getById(ownerUser, folderId);
      dynamic input = jsonDecode(await request.readAsString());
      UserStruct inviteUser = await repos.users.getFromId(input['id']);
      if (!await repos.notify.folders.isParticipant(inviteUser, selectFolder)) {
        await repos.notify.folders.invite(inviteUser, selectFolder);
      } else {
        await repos.notify.folders.exclude(inviteUser, selectFolder);
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
