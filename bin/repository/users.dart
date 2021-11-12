import 'dart:math';

import 'package:postgres/postgres.dart';

import '../structs/user.dart';

class UsersRepository {
  const UsersRepository(this.__executor, this.__tableName);
  final PostgreSQLConnection __executor;
  final String __tableName;

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

  Future<void> add(UserStruct user) async {
    user.id = await _generateId();
    var rows = await __executor.query(
        "INSERT INTO $__tableName (id, first_name, last_name, login, password_hash, colleagues, subscribers, color)"
        " VALUES (@1, @2, @3, @4, @5, ARRAY${user.colleagues}::integer[], ARRAY${user.subscribers}::integer[], @6) RETURNING id",
        substitutionValues: {
          '1': user.id,
          '2': user.firstName,
          '3': user.lastName,
          '4': user.login,
          '5': user.passwordHash,
          '6': user.color,
        });
    user.id = rows[0][0];
  }

  Future<int> getIdFromLoginPassword(String login, String passwordHash) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE login = @1 AND password_hash = @2",
        substitutionValues: {'1': login, '2': passwordHash});
    return data[0][0];
  }

  Future<UserStruct> getFromId(int id) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE id = @1",
        substitutionValues: {'1': id});
    return UserStruct(
      id: data[0][0],
      firstName: data[0][1],
      lastName: data[0][2],
      login: data[0][3],
      passwordHash: data[0][4],
      colleagues: data[0][5],
      subscribers: data[0][6],
      color: data[0][7],
    );
  }

  Future<void> edit(UserStruct user) async {
    await __executor.query(
        "UPDATE $__tableName "
        "SET first_name = @1, last_name = @2, login = @3, "
        "password_hash = @4, color = @5 WHERE id = @6",
        substitutionValues: {
          '1': user.firstName,
          '2': user.lastName,
          '3': user.login,
          '4': user.passwordHash,
          '5': user.color,
          '6': user.id,
        });
  }

  // Future<bool> checkUniqueLogin(String login) async {
  //   var rows = await __executor.query(__tableName,
  //       'SELECT * FROM $__tableName WHERE login = @1', {'1': login});
  //   return rows.isEmpty;
  // }

  // Future<int> getIdByLogin(String login) async {
  //   var rows = await __executor.query(__tableName,
  //       'SELECT id FROM $__tableName WHERE login = @1', {'1': login});
  //   return rows[0][0];
  // }

  // Future<int> getLoginById(int id) async {
  //   var rows = await __executor.query(
  //       __tableName, 'SELECT login FROM $__tableName WHERE id = @1', {'1': id});
  //   return rows[0][0];
  // }

  // Future<UserStruct> getFromId(int id) async {
  //   var rows = await __executor.query(
  //       __tableName, 'SELECT * FROM $__tableName WHERE id = @1', {'1': id});
  //   return UserStruct(
  //     id: rows[0][0],
  //     name: rows[0][1],
  //     login: rows[0][2],
  //     passwordHash: rows[0][3],
  //   );
  // }

  // Future<UserStruct> getFromLogin(String login) async {
  //   return await getFromId(await getIdByLogin(login));
  // }
}
