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
        'SELECT * FROM $__tableName WHERE (owner = @1 OR @1 = ANY(participants)) AND id = @2',
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
