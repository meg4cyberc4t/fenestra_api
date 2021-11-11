ALTER TABLE "refresh_tokens" DROP CONSTRAINT refresh_tokens_fk0;
ALTER TABLE "notifications" DROP CONSTRAINT notifications_fk0;
ALTER TABLE "folders" DROP CONSTRAINT folders_fk0;

DROP TABLE "users";
DROP TABLE "notifications";
DROP TABLE "refresh_tokens";
DROP TABLE "folders";