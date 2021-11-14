import 'package:postgres/postgres.dart';

import 'folders.dart';
import 'notifications.dart';

class NotifyRepository {
  NotifyRepository(this.executor) {
    notifications = NotificationsRepository(
        executor, 'notify_notifications', 'notify_folders');
    folders = FoldersRepository(executor, 'notify_folders');
  }
  final PostgreSQLConnection executor;
  late NotificationsRepository notifications;
  late FoldersRepository folders;
}
