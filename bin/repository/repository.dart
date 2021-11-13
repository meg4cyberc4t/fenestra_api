import 'package:postgres/postgres.dart';

import 'notify/notify.dart';
import 'refresh_tokens.dart';
import 'users.dart';

class Repository {
  Repository(this.executor) {
    users = UsersRepository(executor, 'users');
    refreshTokens = RefreshTokensRepository(executor, 'refresh_tokens');
    notify = NotifyRepository(executor);
  }
  final PostgreSQLConnection executor;
  late UsersRepository users;
  late RefreshTokensRepository refreshTokens;
  late NotifyRepository notify;
}
