class Event {
  final int? id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final String category;
  final String location;
  final int? reminderMinutes;

  Event({
    this.id,
    this.userId = '',
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
    this.category = 'Autre',
    this.location = '',
    this.reminderMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'location': location,
      'reminderMinutes': reminderMinutes,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      userId: map['userId'] ?? '',
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] == 1,
      category: map['category'] ?? 'Autre',
      location: map['location'] ?? '',
      reminderMinutes: map['reminderMinutes'],
    );
  }

  Event copyWith({
    int? id,
    String? userId,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    String? category,
    String? location,
    int? reminderMinutes,
  }) {
    return Event(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      location: location ?? this.location,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    );
  }
}
