class Task {
  final int? id;
  final String description;
  final String time;
  final String whenMustComplete;
  Task(
      {this.id,
      required this.description,
      required this.time,
      required this.whenMustComplete});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'description': description,
      'time': time,
      'whenMustComplete': whenMustComplete
    };

    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['_id'],
      description: map['description'],
      time: map['time'],
      whenMustComplete: map['whenMustComplete'],
    );
  }
}
