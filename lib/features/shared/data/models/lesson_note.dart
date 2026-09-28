class LessonNote {
  const LessonNote({
    required this.id,
    required this.text,
    required this.createdAtMs,
  });

  final String id;
  final String text;
  final int createdAtMs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAtMs': createdAtMs,
      };

  factory LessonNote.fromJson(Map<String, dynamic> json) => LessonNote(
        id: json['id'] as String,
        text: json['text'] as String,
        createdAtMs: (json['createdAtMs'] as int?) ?? (json['createdAt'] as int?) ?? 0,
      );
}
