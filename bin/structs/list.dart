//  id serial unique PRIMARY KEY,
//     owner_id integer not null,
//     moderator_ids integer[] not null,
//     subscribers_ids integer[] not null,
//     title varchar(255) not null,
//     description varchar(255) not null,
//     public boolean not null

class NotificationList {
  NotificationList({
    required this.id,
    required this.ownerId,
    required this.moderatorIds,
    required this.subscribersIds,
    required this.title,
    required this.description,
    required this.public,
  });

  NotificationList.fromJson({
    required Map<String, dynamic> json,
    id,
    ownerId,
    moderatorIds,
    subscribersIds,
    title,
    description,
    public,
  }) {
    this.id = id ?? json['id'];
    this.ownerId = ownerId ?? json['owner_id'];
    this.moderatorIds = moderatorIds ?? json['moderator_ids'];
    this.subscribersIds = subscribersIds ?? json['subscribers_ids'];
    this.title = title ?? json['title'];
    this.description = description ?? json['description'];
    this.public = public ?? json['public'];
  }

  late int id;
  late int ownerId;
  late List<int> moderatorIds;
  late List<int> subscribersIds;
  late String title;
  late String description;
  late bool public;

  Map toMap() {
    return {
      "id": id,
      "owner_id": ownerId,
      "moderator_ids": moderatorIds,
      "subscribers_ids": subscribersIds,
      "title": title,
      "description": description,
      "public": public,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
