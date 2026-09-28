import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/models/course_section.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'package:thaheen_lms/features/shared/logic/progress_rules.dart';

void main() {
  // ── 1. isLessonCompleted (90% Completion Rule) ─────────────
  group('isLessonCompleted', () {
    test('returns false when watched percentage is strictly below 90%', () {
      expect(isLessonCompleted(89, 100), isFalse);
      expect(isLessonCompleted(0, 100), isFalse);
    });

    test('returns true at exactly 90% boundary', () {
      expect(isLessonCompleted(90, 100), isTrue);
      expect(isLessonCompleted(180, 200), isTrue);
    });

    test('returns true when watched percentage is above 90%', () {
      expect(isLessonCompleted(91, 100), isTrue);
      expect(isLessonCompleted(100, 100), isTrue);
      expect(isLessonCompleted(120, 100), isTrue); // handles seeking beyond duration safely
    });

    test('returns false when durationSec is zero or negative (avoids division by zero)', () {
      expect(isLessonCompleted(0, 0), isFalse);
      expect(isLessonCompleted(50, 0), isFalse);
      expect(isLessonCompleted(50, -10), isFalse);
    });
  });

  // ── 2. isLessonUnlocked (Sequential Unlock Rule) ────────────
  group('isLessonUnlocked', () {
    final lessons = [
      const Lesson(id: 'l1', title: 'Lesson 1', durationSec: 100, video: ''),
      const Lesson(id: 'l2', title: 'Lesson 2', durationSec: 100, video: ''),
      const Lesson(id: 'l3', title: 'Lesson 3', durationSec: 100, video: ''),
      const Lesson(id: 'l4', title: 'Lesson 4', durationSec: 100, video: ''),
    ];

    test('first lesson of the course (index 0) is always unlocked unconditionally', () {
      expect(isLessonUnlocked(0, [], lessons), isTrue);
    });

    test('out-of-bounds index returns false safely (fail-safe)', () {
      expect(isLessonUnlocked(-1, ['l1'], lessons), isFalse);
      expect(isLessonUnlocked(99, ['l1', 'l2', 'l3', 'l4'], lessons), isFalse);
    });

    test('second lesson is locked when first lesson is not completed', () {
      expect(isLessonUnlocked(1, [], lessons), isFalse);
    });

    test('second lesson unlocks as soon as first lesson is completed', () {
      expect(isLessonUnlocked(1, ['l1'], lessons), isTrue);
    });

    test('third lesson remains locked if only first lesson is completed', () {
      expect(isLessonUnlocked(2, ['l1'], lessons), isFalse);
    });

    test('third lesson unlocks when immediately preceding lesson is completed', () {
      expect(isLessonUnlocked(2, ['l1', 'l2'], lessons), isTrue);
    });

    // ── Cross-Section Unlock Edge Case ───────────────────────
    test('lesson unlocks only after previous section is fully completed (Cross-Section Progression)', () {
      // Scenario: Section 1 has [l1, l2] -> Section 2 begins with l3 (global index 2).
      // l3 MUST stay locked if l1 is completed but l2 (last lesson of Section 1) is not completed:
      expect(isLessonUnlocked(2, ['l1'], lessons), isFalse);

      // l3 unlocks once all preceding lessons [l1, l2] are completed:
      expect(isLessonUnlocked(2, ['l1', 'l2'], lessons), isTrue);
    });
  });

  // ── 3. courseProgressPercent (Progress % Calculation) ──────
  group('courseProgressPercent', () {
    final lessons = [
      const Lesson(id: 'l1', title: 'Lesson 1', durationSec: 100, video: ''),
      const Lesson(id: 'l2', title: 'Lesson 2', durationSec: 100, video: ''),
      const Lesson(id: 'l3', title: 'Lesson 3', durationSec: 100, video: ''),
      const Lesson(id: 'l4', title: 'Lesson 4', durationSec: 100, video: ''),
    ];

    test('returns 0.0 when no lessons are completed', () {
      expect(courseProgressPercent(lessons, []), equals(0.0));
    });

    test('returns 0.25 when one out of four lessons is completed', () {
      expect(courseProgressPercent(lessons, ['l1']), equals(0.25));
    });

    test('returns 0.5 when half of the lessons are completed', () {
      expect(courseProgressPercent(lessons, ['l1', 'l2']), equals(0.5));
    });

    test('returns 1.0 when all lessons are completed', () {
      expect(courseProgressPercent(lessons, ['l1', 'l2', 'l3', 'l4']), equals(1.0));
    });

    test('returns 0.0 when course has an empty lesson list (avoids division by zero)', () {
      expect(courseProgressPercent([], ['l1']), equals(0.0));
    });

    test('ignores unrelated lesson IDs in completed list', () {
      expect(courseProgressPercent(lessons, ['random_id_999']), equals(0.0));
      expect(courseProgressPercent(lessons, ['l1', 'random_id']), equals(0.25));
    });
  });

  // ── 4. Course Model Convenience Helpers ──────────────────
  group('Course helpers', () {
    const course = Course(
      id: 'anatomy-101',
      title: 'مقدمة في التشريح',
      instructor: 'د. سارة',
      thumbnail: 'assets/images/anatomy.png',
      sections: [
        CourseSection(
          id: 's1',
          title: 'الجهاز الهيكلي',
          lessons: [
            Lesson(id: 'l1', title: 'العظام', durationSec: 95, video: ''),
            Lesson(id: 'l2', title: 'المفاصل', durationSec: 110, video: ''),
          ],
        ),
        CourseSection(
          id: 's2',
          title: 'الجهاز العضلي',
          lessons: [Lesson(id: 'l3', title: 'أنواع العضلات', durationSec: 120, video: '')],
        ),
      ],
    );

    test('courseLessonCount calculates total count across all sections', () {
      expect(courseLessonCount(course), equals(3));
      expect(course.totalLessons, equals(3));
    });

    test('courseCompletionPercent calculates accurate progress across course sections', () {
      expect(courseCompletionPercent(course, []), equals(0.0));
      expect(courseCompletionPercent(course, ['l1']), closeTo(0.333, 0.01));
      expect(courseCompletionPercent(course, ['l1', 'l2']), closeTo(0.666, 0.01));
      expect(courseCompletionPercent(course, ['l1', 'l2', 'l3']), equals(1.0));
    });

    test('course.allLessons returns ordered flattened list', () {
      final ids = course.allLessons.map((l) => l.id).toList();
      expect(ids, equals(['l1', 'l2', 'l3']));
    });
  });
}
