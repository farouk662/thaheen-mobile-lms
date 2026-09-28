import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/features/course_details/presentation/widgets/lesson_status_badge.dart';
import 'package:thaheen_lms/features/course_details/presentation/widgets/lesson_tile.dart';
import 'package:thaheen_lms/features/shared/data/models/course_details_data.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';

Widget _buildTestSubject(Widget child) {
  return MaterialApp(
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)),
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppStrings.init();
  });

  const testLesson = Lesson(id: 'l1', title: 'العظام', titleEn: 'Bones', durationSec: 14, video: 'assets/videos/lesson1.mp4');

  group('LessonTile Widget Tests', () {
    testWidgets('1. Locked state renders lock icon, hides status badge, and triggers onLockedTap', (tester) async {
      var tapCount = 0;
      var lockedTapCount = 0;

      const lessonRow = LessonRow(lesson: testLesson, status: LessonStatus.notStarted, isLocked: true, positionSec: 0);

      await tester.pumpWidget(
        _buildTestSubject(LessonTile(lessonRow: lessonRow, onTap: () => tapCount++, onLockedTap: () => lockedTapCount++)),
      );

      // Verify UI elements for locked state
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
      expect(find.byType(LessonStatusBadge), findsNothing);
      expect(find.text('العظام'), findsOneWidget);

      // Tap should invoke onLockedTap, NOT onTap
      await tester.tap(find.byType(LessonTile));
      await tester.pump();

      expect(lockedTapCount, equals(1));
      expect(tapCount, equals(0));
    });

    testWidgets('2. Completed state renders checkmark, completed badge, and triggers onTap', (tester) async {
      var tapCount = 0;
      var lockedTapCount = 0;

      const lessonRow = LessonRow(lesson: testLesson, status: LessonStatus.completed, isLocked: false, positionSec: 14);

      await tester.pumpWidget(
        _buildTestSubject(LessonTile(lessonRow: lessonRow, onTap: () => tapCount++, onLockedTap: () => lockedTapCount++)),
      );

      // Verify UI elements for completed state
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.lock_rounded), findsNothing);
      expect(find.byType(LessonStatusBadge), findsOneWidget);
      expect(find.text(AppStrings.lessonCompleted), findsOneWidget);

      // Tap should invoke onTap, NOT onLockedTap
      await tester.tap(find.byType(LessonTile));
      await tester.pump();

      expect(tapCount, equals(1));
      expect(lockedTapCount, equals(0));
    });

    testWidgets('3. Available/In-progress state renders play icon, in-progress badge, and triggers onTap', (tester) async {
      var tapCount = 0;
      var lockedTapCount = 0;

      const lessonRow = LessonRow(lesson: testLesson, status: LessonStatus.inProgress, isLocked: false, positionSec: 7);

      await tester.pumpWidget(
        _buildTestSubject(LessonTile(lessonRow: lessonRow, onTap: () => tapCount++, onLockedTap: () => lockedTapCount++)),
      );

      // Verify UI elements for in-progress state
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(find.byType(LessonStatusBadge), findsOneWidget);
      expect(find.text(AppStrings.lessonInProgress), findsOneWidget);

      // Tap should invoke onTap
      await tester.tap(find.byType(LessonTile));
      await tester.pump();

      expect(tapCount, equals(1));
      expect(lockedTapCount, equals(0));
    });
  });
}
