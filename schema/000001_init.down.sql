ALTER TABLE "notify_notifications" DROP CONSTRAINT notify_notifications_fk0;
ALTER TABLE "notify_notifications" DROP CONSTRAINT notify_notifications_fk1;
ALTER TABLE "notify_folders" DROP CONSTRAINT notify_folders_fk0;
ALTER TABLE "refresh_tokens" DROP CONSTRAINT refresh_tokens_fk0;

DROP TABLE "users";
DROP TABLE "refresh_tokens";
DROP TABLE "notify_notifications";
DROP TABLE "notify_folders";