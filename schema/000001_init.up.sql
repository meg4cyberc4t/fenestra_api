CREATE TABLE "users" (
	"id" integer UNIQUE PRIMARY KEY,
	"first_name" varchar NOT NULL,
	"last_name" varchar NOT NULL,
	"login" varchar NOT NULL UNIQUE,
	"password_hash" varchar NOT NULL,
	"color" integer NOT NULL CHECK(color >=0 AND color <= 16777215)
);

CREATE TABLE "bonds_collegues" (
	"id" integer UNIQUE PRIMARY KEY,
	"user1" integer NOT NULL,
	"user2" integer NOT NULL
);

ALTER TABLE "bonds_collegues" ADD CONSTRAINT "bonds_collegues_fk0" FOREIGN KEY ("user1") REFERENCES "users"("id");
ALTER TABLE "bonds_collegues" ADD CONSTRAINT "bonds_collegues_fk1" FOREIGN KEY ("user2") REFERENCES "users"("id");


CREATE TABLE "bonds_subscriptions" (
	"id" integer UNIQUE PRIMARY KEY,
	"from" integer NOT NULL,
	"to" integer NOT NULL
);

ALTER TABLE "bonds_subscriptions" ADD CONSTRAINT "bonds_subscriptions_fk0" FOREIGN KEY ("from") REFERENCES "users"("id");
ALTER TABLE "bonds_subscriptions" ADD CONSTRAINT "bonds_subscriptions_fk1" FOREIGN KEY ("to") REFERENCES "users"("id");

CREATE TABLE "refresh_tokens" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"token" varchar NOT NULL
);

ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");


CREATE TABLE "notify_folders" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" varchar(255),
	"participants" integer[] DEFAULT ARRAY[]::integer[], 
	"priority" smallint DEFAULT 0
);

ALTER TABLE "notify_folders" ADD CONSTRAINT "notify_folders_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");

CREATE TABLE "notify_folders_participants" (
	"id" integer UNIQUE PRIMARY KEY,
	"folder" integer NOT NULL,
	"user" integer NOT NULL
);

ALTER TABLE "notify_folders_participants" ADD CONSTRAINT "notify_folders_participants_fk0" FOREIGN KEY ("folder") REFERENCES "notify_folders"("id");
ALTER TABLE "notify_folders_participants" ADD CONSTRAINT "notify_folders_participants_fk1" FOREIGN KEY ("user") REFERENCES "users"("id");

CREATE TABLE "notify_notifications" (
	"id" integer UNIQUE PRIMARY KEY,
	"owner" integer NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" varchar(255),
	"deadline" bigint,
	"repeat" smallint,
	"folder" integer
);

ALTER TABLE "notify_notifications" ADD CONSTRAINT "notify_notifications_fk0" FOREIGN KEY ("owner") REFERENCES "users"("id");
ALTER TABLE "notify_notifications" ADD CONSTRAINT "notify_notifications_fk1" FOREIGN KEY ("folder") REFERENCES "notify_folders"("id");

CREATE TABLE "notify_notifications_participants" (
	"id" integer UNIQUE PRIMARY KEY,
	"notification" integer NOT NULL,
	"user" integer NOT NULL
);

ALTER TABLE "notify_notifications_participants" ADD CONSTRAINT "notify_notifications_participants_fk0" FOREIGN KEY ("notification") REFERENCES "notify_notifications"("id");
ALTER TABLE "notify_notifications_participants" ADD CONSTRAINT "notify_notifications_participants_fk1" FOREIGN KEY ("user") REFERENCES "users"("id");
