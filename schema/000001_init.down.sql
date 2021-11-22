ALTER TABLE "notify_notifications" DROP CONSTRAINT notify_notifications_fk0;
ALTER TABLE "notify_notifications" DROP CONSTRAINT notify_notifications_fk1;

ALTER TABLE "notify_folders" DROP CONSTRAINT notify_folders_fk0;

ALTER TABLE "refresh_tokens" DROP CONSTRAINT refresh_tokens_fk0;

ALTER TABLE "bonds_collegues" DROP CONSTRAINT bonds_collegues_fk0;
ALTER TABLE "bonds_collegues" DROP CONSTRAINT bonds_collegues_fk1;

ALTER TABLE "bonds_subscriptions" DROP CONSTRAINT bonds_subscriptions_fk0;
ALTER TABLE "bonds_subscriptions" DROP CONSTRAINT bonds_subscriptions_fk1;

ALTER TABLE "notify_folders_participants" DROP CONSTRAINT notify_folders_participants_fk0;
ALTER TABLE "notify_folders_participants" DROP CONSTRAINT notify_folders_participants_fk1;

ALTER TABLE "notify_notifications_participants" DROP CONSTRAINT notify_notifications_participants_fk0;
ALTER TABLE "notify_notifications_participants" DROP CONSTRAINT notify_notifications_participants_fk1;

DROP TABLE "users";

DROP TABLE "refresh_tokens";

DROP TABLE "notify_notifications";
DROP TABLE "notify_folders";

DROP TABLE "bonds_collegues";
DROP TABLE "bonds_subscriptions";

DROP TABLE "notify_folders_participants";
DROP TABLE "notify_notifications_participants";

