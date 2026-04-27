class Incident {
  final int? id;
  final String task;
  final String description;
  final String date; // ISO string

  Incident({
    this.id,
    required this.task,
    required this.description,
    required this.date,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'task': task,
        'description': description,
        'date': date,
      };

  factory Incident.fromMap(Map<String, Object?> m) => Incident(
        id: m['id'] as int?,
        task: m['task'] as String,
        description: m['description'] as String,
        date: m['date'] as String,
      );
}
