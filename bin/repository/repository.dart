import 'package:angel3_orm_postgres/angel3_orm_postgres.dart';

import 'items_repository.dart';
import 'lists_repository.dart';
import 'referrals_repository.dart';
import 'refresh_tokens_repository.dart';
import 'user_repository.dart';

class Repository {
  Repository(this.executor) {
    users = UsersRepository(executor, 'users');
    lists = NotificationListsRepository(executor, 'notification_lists');
    items = NotificationItemRepository(executor, 'notification_items');
    tokens = RefreshTokensRepository(executor, 'refresh_tokens');
    referrals = ReferralsForListsRepository(executor, 'referrals_for_lists');
  }
  final PostgreSqlExecutorPool executor;
  late UsersRepository users;
  late NotificationListsRepository lists;
  late NotificationItemRepository items;
  late RefreshTokensRepository tokens;
  late ReferralsForListsRepository referrals;
}
