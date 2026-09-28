class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    this.titleEn,
    required this.durationSec,
    required this.video,
  });

  final String id;
  final String title;
  final String? titleEn;
  final int durationSec;
  final String video;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      durationSec: json['durationSec'] as int,
      video: json['video'] as String,
    );
  }
}
