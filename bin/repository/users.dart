import 'dart:math';

import 'package:postgres/postgres.dart';

import '../structs/user.dart';

class UsersRepository {
  const UsersRepository(this.__executor, this.__tableName);
  final PostgreSQLConnection __executor;
  final String __tableName;

  Future<int> _generateId() async {
    int id = Random().nextInt(2147483647);
    while (!await isUniqueId(id)) {
      id = Random().nextInt(2147483647);
    }
    return id;
  }

  Future<bool> isUniqueId(int id) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE id = @1",
        substitutionValues: {'1': id});
    return data.isEmpty ? true : data[0].isEmpty;
  }

  Future<bool> isUniqueLogin(String login) async {
    var data = await __executor.query(
        "SELECT * FROM  $__tableName WHERE login = @1",
        substitutionValues: {'1': login});
    return data.isEmpty ? true : data[0].isEmpty;
  }

  Future<void> add(UserStruct user) async {
    user.id = await _generateId();
    var rows = await __executor.query(
        "INSERT INTO $__tableName (id, first_name, last_name, login, password_hash, color)"
        " VALUES (@1, @2, @3, @4, @5, @6) RETURNING id",
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
        "SELECT id FROM  $__tableName WHERE login = @1 AND password_hash = @2",
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
      color: data[0][5],
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

  Future<bool> isCollegues(UserStruct firstUser, UserStruct secondUser) async {
    var data = await __executor.query(
        "SELECT * FROM bonds_collegues "
        "WHERE (user1 = @1 AND user2 = @2) OR  (user2 = @1 AND user1 = @2)",
        substitutionValues: {
          '1': firstUser.id,
          '2': secondUser.id,
        });
    return data.isEmpty ? false : data[0].isNotEmpty;
  }

  Future<void> setCollegues(UserStruct firstUser, UserStruct secondUser) async {
    await __executor.query(
        "INSERT INTO bonds_collegues(user1, user2) VALUES (@1, @2)",
        substitutionValues: {
          '1': firstUser.id,
          '2': secondUser.id,
        });
  }

  Future<void> deleteCollegues(
      UserStruct firstUser, UserStruct secondUser) async {
    await __executor.query(
        "DELETE FROM bonds_collegues(user1, user2) "
        "WHERE (user1 = @1 AND user2 = @2) OR  (user2 = @1 AND user1 = @2",
        substitutionValues: {
          '1': firstUser.id,
          '2': secondUser.id,
        });
  }

  Future<bool> isSubscribe(UserStruct user1, UserStruct user2) async {
    var data = await __executor.query(
        "SELECT * FROM bonds_subscriptions "
        "WHERE (from = @1 AND to = @2)",
        substitutionValues: {
          '1': user1.id,
          '2': user2.id,
        });
    return data.isEmpty ? false : data[0].isNotEmpty;
  }

  Future<void> setSubscribe(UserStruct from, UserStruct to) async {
    await __executor.query(
        "INSERT INTO bonds_subscriptions(from, to) VALUES (@1, @2)",
        substitutionValues: {
          '1': from.id,
          '2': to.id,
        });
  }

  Future<bool> deleteSubscribe(UserStruct user1, UserStruct user2) async {
    var data = await __executor.query(
        "DELETE FROM bonds_subscriptions "
        "WHERE (from = @1 AND to = @2)",
        substitutionValues: {
          '1': user1.id,
          '2': user2.id,
        });
    return data.isEmpty ? false : data[0].isNotEmpty;
  }

  // Future<void> bond(UserStruct user, UserStruct bondUser) async {
  //   // Если оба есть в коллегах

  //   // Если один подписан на второго

  //   // Если второй подписан на первого

  //   // Если никто не подписан
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET colleagues = array_append(colleagues, @2)"
  //       "WHERE id = @1",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET colleagues = array_append(colleagues, @1)"
  //       "WHERE id = @2",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  // }

  // Future<void> deleteBond(UserStruct user, UserStruct bondUser) async {
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET colleagues = array_remove(colleagues, @2)"
  //       "WHERE id = @1",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET colleagues = array_remove(colleagues, @1)"
  //       "WHERE id = @2",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  // }

  // Future<void> addSubscriptions(UserStruct user, UserStruct bondUser) async {
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET subscriptions = array_append(subscriptions, @2)"
  //       "WHERE id = @1",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET subscribers = array_append(subscribers, @1)"
  //       "WHERE id = @2",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  // }

  // Future<void> deleteSubscriptions(UserStruct user, UserStruct bondUser) async {
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET subscriptions = array_remove(subscriptions, @2)"
  //       "WHERE id = @1",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  //   await __executor.query(
  //       "UPDATE $__tableName "
  //       "SET subscribers = array_remove(subscribers, @1)"
  //       "WHERE id = @2",
  //       substitutionValues: {
  //         '1': user.id,
  //         '2': bondUser.id,
  //       });
  // }
}
