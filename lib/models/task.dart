class Task {
  final String id;
  final String title;
  final bool done;

  Task({
    required this.id,
    required this.title,
    this.done = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  @override
  String toString() => 'Task(id: $id, title: $title, done: $done)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.done == done;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ done.hashCode;
}

