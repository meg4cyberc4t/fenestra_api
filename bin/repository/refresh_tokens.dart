import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

import '../structs/refresh_token.dart';

class RefreshTokensRepository {
  const RefreshTokensRepository(this.__executor, this.__tableName);
  final PostgreSqlExecutorPool __executor;
  final String __tableName;

  Future<void> write(int ownerId, String refreshToken) async {
    await __executor.query(__tableName,
        "INSERT INTO $__tableName (owner_id, token) VALUES (@1, @2)", {
      '1': ownerId,
      '2': refreshToken,
    });
  }

  Future<RefreshToken> get(String refreshToken) async {
    var rows = await __executor.query(__tableName,
        'SELECT * FROM $__tableName WHERE token = @1', {'1': refreshToken});
    return RefreshToken(id: rows[0][0], ownerId: rows[0][1], token: rows[0][2]);
  }

  Future<void> rewrite(int refreshTokenId, String newRefreshToken) async {
    await __executor.query(
        __tableName,
        'UPDATE $__tableName SET token = @1 WHERE id = @2',
        {'1': newRefreshToken, '2': refreshTokenId});
  }
}
