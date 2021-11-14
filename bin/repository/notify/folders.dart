import 'dart:math';

import 'package:postgres/postgres.dart';

import '../../structs/notify/folder.dart';
import '../../structs/user.dart';

class FoldersRepository {
  const FoldersRepository(this.__executor, this.__tableName);
  final PostgreSQLConnection __executor;
  final String __tableName;

  Future<List<FolderStruct>> get(UserStruct user) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE owner = @1 OR @1 = ANY(participants)',
        substitutionValues: {'1': user.id});
    List<FolderStruct> data = [];
    for (var e in rows) {
      data.add(FolderStruct(
          id: e[0],
          owner: e[1],
          title: e[2],
          description: e[3],
          participants: e[4],
          priority: e[5]));
    }
    return data;
  }

  Future<FolderStruct> getById(UserStruct user, int id) async {
    var rows = await __executor.query(
        'SELECT * FROM $__tableName WHERE owner = @1 OR @1 = ANY(participants) AND id = @3',
        substitutionValues: {'1': user.id, '2': id});
    return FolderStruct(
        id: rows[0][0],
        owner: rows[0][1],
        title: rows[0][2],
        description: rows[0][3],
        participants: rows[0][4],
        priority: rows[0][5]);
  }

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

  Future<void> add(FolderStruct folder) async {
    folder.id = await _generateId();
    var rows = await __executor.query(
        "INSERT INTO $__tableName (id, owner, title, description, participants, priority)"
        " VALUES (@1, @2, @3, @4, ARRAY${folder.participants}::integer[], @6) RETURNING id",
        substitutionValues: {
          '1': folder.id,
          '2': folder.owner,
          '3': folder.title,
          '4': folder.description,
          '5': folder.participants,
          '6': folder.priority,
        });
    folder.id = rows[0][0];
  }

  Future<void> delete(UserStruct user, FolderStruct folder) async {
    await __executor.query(
        "DELETE FROM $__tableName WHERE id = @1 AND owner = @2",
        substitutionValues: {
          '1': folder.id,
          '2': user.id,
        });
  }

  Future<void> edit(UserStruct user, FolderStruct folder) async {
    await __executor.query(
        "UPDATE $__tableName "
        "SET title = @4, description = @5, priority = @6 "
        "WHERE owner = @1 AND owner = @2 AND id = @3",
        substitutionValues: {
          '1': user.id,
          '2': folder.owner,
          '3': folder.id,
          '4': folder.title,
          '5': folder.description,
          '6': folder.priority,
        });
  }

  Future<void> invite(UserStruct user, FolderStruct folder) async {
    await __executor.query(
        "UPDATE $__tableName "
        "SET participants = array_append(participants, @1)"
        "WHERE id = @2",
        substitutionValues: {
          '1': user.id,
          '2': folder.id,
        });
  }

  Future<void> exclude(UserStruct user, FolderStruct folder) async {
    await __executor.query(
        "UPDATE $__tableName "
        "SET participants = array_remove(participants, @1)"
        "WHERE id = @2",
        substitutionValues: {
          '1': user.id,
          '2': folder.id,
        });
  }
}

// import '../structs/notification.dart';

// class NotificationListsRepository {
//   const NotificationListsRepository(this.__executor, this.__tableName);
//   final PostgreSqlExecutorPool __executor;
//   final String __tableName;

//   // Future<void> create(NotificationStruct list) async {
//   //   var rows = await __executor.query(
//   //       __tableName,
//   //       "INSERT INTO $__tableName"
//   //       "(owner_id, moderator_ids, subscribers_ids, title, description, public)"
//   //       "VALUES (@1, ARRAY${list.moderatorIds}::integer[], ARRAY${list.subscribersIds}::integer[], @4, @5, @6) RETURNING id",
//   //       {
//   //         '1': list.ownerId,
//   //         '4': list.title,
//   //         '5': list.description,
//   //         '6': list.public,
//   //       });
//   //   list.id = rows[0][0];
//   // }

//   // Future<void> delete(int listId, int userId) async {
//   //   await __executor.query(
//   //       __tableName,
//   //       'DELETE FROM $__tableName WHERE id = @1 AND owner_id = @2',
//   //       {'1': listId, '2': userId});
//   // }

//   // Future<NotificationStruct> getById(int listId, int userId) async {
//   //   var data = await __executor.query(
//   //       __tableName,
//   //       'SELECT *  FROM $__tableName'
//   //       ' WHERE id = @1 AND owner_id = @2 '
//   //       'OR @2 = ANY(subscribers_ids) OR @2 = ANY(moderator_ids)',
//   //       {'1': listId, '2': userId});
//   //   return NotificationStruct(
//   //     id: data[0][0],
//   //     ownerId: data[0][1],
//   //     moderatorIds: data[0][2],
//   //     subscribersIds: data[0][3],
//   //     title: data[0][4],
//   //     description: data[0][5],
//   //     public: data[0][6],
//   //   );
//   // }

//   // Future<void> edit(NotificationStruct list) async {
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET title = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.title,
//   //   });
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET description = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.description,
//   //   });
//   //   print('2');
//   //   await __executor.query(
//   //       __tableName, "UPDATE $__tableName SET public = @2 WHERE id = @1", {
//   //     '1': list.id,
//   //     '2': list.public,
//   //   });
//   // }
// }
