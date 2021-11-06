import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

import '../structs/list.dart';
import '../structs/user.dart';

const tableUsers = 'users';
const tableRefreshTokens = 'refresh_tokens';
const tableReferrals = 'referrals_for_lists';
const tableNotificationList = 'notification_lists';
const tableNotificationItems = 'notification_items';

class Repository {
  const Repository(this.executor);
  final PostgreSqlExecutorPool executor;

  Future<bool> checkUniqueLogin(String login) async {
    var rows = await executor.query(
        tableUsers, 'SELECT * FROM $tableUsers WHERE login = @1', {'1': login});
    return rows.isEmpty;
  }

  Future<void> addNewUser(User user) async {
    var rows = await executor.query(
        tableUsers,
        'INSERT INTO $tableUsers (name, login, password_hash) VALUES (@1, @2, @3) RETURNING id',
        {
          '1': user.name,
          '2': user.login,
          '3': user.passwordHash,
        });
    user.id = rows[0][0];
  }

  Future<void> writeRefreshToken(User user, String refreshToken) async {
    await executor.query(tableRefreshTokens,
        "INSERT INTO $tableRefreshTokens (owner_id, token) VALUES (@1, @2)", {
      '1': user.id,
      '2': refreshToken,
    });
  }

  Future<int> getIdByLogin(String login) async {
    var rows = await executor.query(tableUsers,
        'SELECT id FROM $tableUsers WHERE login = @1', {'1': login});
    return rows[0][0];
  }

  Future<String> getPasswordHashById(int id) async {
    var rows = await executor.query(tableUsers,
        'SELECT password_hash FROM $tableUsers WHERE id = @1', {'1': id});
    return rows[0][0];
  }

  Future<int> getIdRefreshTokenByRefreshToken(String refreshToken) async {
    var rows = await executor.query(
        tableRefreshTokens,
        'SELECT id FROM $tableRefreshTokens WHERE token = @1',
        {'1': refreshToken});
    return rows[0][0];
  }

  Future<void> rewriteRefreshTokenByRefreshTokenId(
      String newRefreshToken, int refreshTokenId) async {
    await executor.query(
        tableRefreshTokens,
        'UPDATE $tableRefreshTokens SET token = @1 WHERE id = @2',
        {'1': newRefreshToken, '2': refreshTokenId});
  }

  Future<int> getOwnerIdByRefreshToken(String refreshToken) async {
    var rows = await executor.query(
        tableRefreshTokens,
        'SELECT owner_id FROM $tableRefreshTokens WHERE token = @1',
        {'1': refreshToken});
    return rows[0][0];
  }

  Future<User> getUserfromId(int id) async {
    var rows = await executor.query(
        tableUsers, 'SELECT * FROM $tableUsers WHERE id = @1', {'1': id});
    return User(
        id: rows[0][0],
        name: rows[0][1],
        login: rows[0][2],
        passwordHash: rows[0][3]);
  }

  Future<void> createNotificationListByList(NotificationList list) async {
    var rows = await executor.query(
        tableNotificationList,
        "INSERT INTO $tableNotificationList"
        "(owner_id, moderator_ids, subscribers_ids, title, description, public)"
        "VALUES (@1, ARRAY${list.moderatorIds}, ARRAY${list.subscribersIds}, @4, @5, @6) RETURNING id",
        {
          '1': list.ownerId,
          '4': list.title,
          '5': list.description,
          '6': list.public,
        });
    list.id = rows[0][0];
  }

  Future<List<NotificationList>> getListsByUserId(int id) async {
    var rows = await executor.query(
        tableUsers,
        'SELECT * FROM $tableNotificationList WHERE owner_id = @1 OR @1 = ANY(subscribers_ids)',
        {'1': id});
    List<NotificationList> lists = [];
    for (var parseList in rows) {
      if (parseList.isEmpty) {
        continue;
      }
      lists.add(NotificationList(
        id: parseList[0],
        ownerId: parseList[1],
        moderatorIds: parseList[2],
        subscribersIds: parseList[3],
        title: parseList[4],
        description: parseList[5],
        public: parseList[6],
      ));
    }
    return lists;
  }

  Future<bool> getCheckRight(int userid, int listid) async {
    // Возвращает true если права есть
    List<List<dynamic>> rows = await executor.query(
        tableNotificationList,
        'SELECT id FROM $tableNotificationList WHERE owner_id = @1 OR @1 = ANY(subscribers_ids) AND id = @2',
        {
          '1': userid,
          '2': listid,
        });
    return rows.isNotEmpty && rows[0].isNotEmpty;
  }

  Future<bool> deleteNotificationListById(int listid, int ownerid) async {
    var data = await executor.query(
        tableNotificationList,
        'DELETE FROM $tableNotificationList WHERE id = @1 AND owner_id = @2 RETURNING id',
        {'1': listid, '2': ownerid});
    return data[0].isNotEmpty;
  }
}
