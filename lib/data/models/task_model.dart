class Task {
  Task({
    required this.createdDate,
    required this.description,
    required this.id,
    required this.title,
    required this.email,
    required this.status,
  });

  DateTime createdDate;
  String description;
  String id;
  String title;
  String email;
  String status;

  factory Task.fromJson(Map<dynamic, dynamic> json) => Task(
    createdDate: DateTime.parse(json["createdDate"]),
    description: json["description"],
    id: json["_id"],
    title: json["title"],
    email: json["email"],
    status: json["status"],
  );

  Map<dynamic, dynamic> toJson() => {
    "createdDate": createdDate.toIso8601String(),
    "description": description,
    "_id": id,
    "title": title,
    "email": email,
    "status": status,
  };
}
