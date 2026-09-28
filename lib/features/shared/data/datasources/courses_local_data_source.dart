import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class CoursesLocalDataSource {
  List<Course>? _cache;

  Future<List<Course>> getCourses() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString('assets/data/courses.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final list = jsonMap['courses'] as List<dynamic>;
    _cache = list.map((c) => Course.fromJson(c as Map<String, dynamic>)).toList();
    return _cache!;
  }
}
