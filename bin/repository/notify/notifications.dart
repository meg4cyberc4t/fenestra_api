import 'dart:math';

import 'package:postgres/postgres.dart';

import '../../structs/notify/folder.dart';
import '../../structs/notify/notification.dart';
import '../../structs/user.dart';

class NotificationsRepository {
  const NotificationsRepository(
      this.__executor, this.__tableName, this.__folderTableName);
  final PostgreSQLConnection __executor;
  final String __tableName;
  final String __folderTableName;

  Future<int> _generateId() async {
    int id = Random().nextInt(2147483647);
    while (!await _isUniqueId(id)) {
      id = Random().nextInt(2147483647);
    }
    return id;
  }

  Future<bool> _isUniqueId(int id) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE id = @1",
        substitutionValues: {'1': id});
    return data.isEmpty ? true : data[0].isEmpty;
  }

  Future<void> add(NotificationStruct notification) async {
    notification.id = await _generateId();
    var rows = await __executor.query(
        "INSERT INTO $__tableName (id, owner, title, description, deadline, repeat, folder)"
        " VALUES (@1, @2, @3, @4, @5, @6, @7) RETURNING id",
        substitutionValues: {
          '1': notification.id,
          '2': notification.owner,
          '3': notification.title,
          '4': notification.description,
          '5': notification.deadline,
          '6': notification.repeat,
          '7': notification.folder,
        });
    notification.id = rows[0][0];
  }

  Future<List<NotificationStruct>> get(UserStruct user) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE owner = @1 OR @1 = ANY(invited) OR folder = ANY(SELECT id FROM $__folderTableName where @1 = ANY(participants))',
        substitutionValues: {'1': user.id});
    List<NotificationStruct> data = [];
    for (var e in rows) {
      data.add(
        NotificationStruct(
          id: e[0],
          owner: e[1],
          title: e[2],
          description: e[3],
          deadline: e[4],
          repeat: e[5],
          folder: e[6],
        ),
      );
    }
    return data;
  }

  Future<NotificationStruct> getById(UserStruct user, int id) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE owner = @1 AND id = @2',
        substitutionValues: {'1': user.id, '2': id});
    return NotificationStruct(
      id: rows[0][0],
      owner: rows[0][1],
      title: rows[0][2],
      description: rows[0][3],
      deadline: rows[0][4],
      repeat: rows[0][5],
      folder: rows[0][6],
    );
  }

  Future<List<NotificationStruct>> getByFolder(FolderStruct folder) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE folder = @1',
        substitutionValues: {'1': folder.id});
    List<NotificationStruct> data = [];
    for (var e in rows) {
      data.add(
        NotificationStruct(
          id: e[0],
          owner: e[1],
          title: e[2],
          description: e[3],
          deadline: e[4],
          repeat: e[5],
          folder: e[6],
        ),
      );
    }
    return data;
  }

  Future<void> edit(UserStruct user, NotificationStruct notification) async {
    await __executor.query(
        "UPDATE $__tableName "
        "SET title = @4, description = @5, deadline = @6, repeat = @7, folder = @8 "
        "WHERE owner = @1 AND owner = @2 AND id = @3",
        substitutionValues: {
          '1': user.id,
          '2': notification.owner,
          '3': notification.id,
          '4': notification.title,
          '5': notification.description,
          '6': notification.deadline,
          '7': notification.repeat,
          '8': notification.folder,
        });
  }

  Future<void> invite(UserStruct user, NotificationStruct notification) async {
    await __executor.query(
        "INSERT INTO notify_notifications_participants (notification, user)"
        "VALUES (@2, @1)",
        substitutionValues: {
          '1': user.id,
          '2': notification.id,
        });
  }

  Future<void> exclude(UserStruct user, NotificationStruct notification) async {
    await __executor.query(
        "DELETE FROM notify_notifications_participants "
        "WHERE notification = @2 AND user = @1",
        substitutionValues: {
          '1': user.id,
          '2': notification.id,
        });
  }

  Future<bool> isParticipant(
      UserStruct user, NotificationStruct notification) async {
    var data = await __executor.query(
        "SELECT * FROM notify_notifications_participants WHERE user = @1 AND notification = @2",
        substitutionValues: {
          '1': user.id,
          '2': notification.id,
        });
    return data.isEmpty ? true : data[0].isEmpty;
  }
}
