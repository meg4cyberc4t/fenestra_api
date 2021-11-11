import 'package:postgres/postgres.dart';

import 'folders.dart';
import 'notifications.dart';
import 'refresh_tokens.dart';
import 'users.dart';

class Repository {
  Repository(this.executor) {
    users = UsersRepository(executor, 'users');
    notifications = NotificationsRepository(executor, 'notifications');
    folders = FoldersRepository(executor, 'folders');
    refreshTokens = RefreshTokensRepository(executor, 'refresh_tokens');
  }
  final PostgreSQLConnection executor;
  late UsersRepository users;
  late NotificationsRepository notifications;
  late FoldersRepository folders;
  late RefreshTokensRepository refreshTokens;
}
