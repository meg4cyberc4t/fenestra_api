BEGIN;
CREATE TABLE users 
(
    id serial unique PRIMARY KEY,
    name varchar(255) not null,
    login varchar(255) not null unique,
    password_hash varchar(255) not null
);

CREATE TABLE referrals
(
    id serial unique PRIMARY KEY,
    owner_id integer not null,
    list_id integer not null,
    code varchar(255) not null,
    alive boolean not null

);

CREATE TABLE notification_lists
(
    id serial unique PRIMARY KEY,
    owner_id integer not null,
    moderator_ids integer[] not null,
    subscribers_ids integer[] not null,
    title varchar(255) not null,
    description varchar(255) not null,
    public boolean not null

);

CREATE TABLE notification_items
(
    id serial unique PRIMARY KEY,
    list_id integer not null,
    title varchar(255) not null,
    description varchar(255),
    deadline integer,
    owner_id integer not null

);

CREATE TABLE refresh_tokens
(
    id serial unique PRIMARY KEY,
    owner_id integer not null,
    token varchar(255) not null unique
);
COMMIT;