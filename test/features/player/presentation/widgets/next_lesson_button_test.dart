import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/widgets/adaptive/app_forward_icon.dart';
import 'package:thaheen_lms/features/player/presentation/widgets/next_lesson_button.dart';
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

  const nextLesson = Lesson(
    id: 'l2',
    title: 'المفاصل والغضاريف',
    titleEn: 'Joints & Cartilage',
    durationSec: 44,
    video: 'assets/videos/lesson2.mp4',
  );

  group('NextLessonButton Widget Tests', () {
    testWidgets('1. Locked next lesson renders lock icon and invokes onLockedTap', (tester) async {
      var nextTapCount = 0;
      var lockedTapCount = 0;

      await tester.pumpWidget(
        _buildTestSubject(
          NextLessonButton(nextLesson: nextLesson, isUnlocked: false, onNextTap: () => nextTapCount++, onLockedTap: () => lockedTapCount++),
        ),
      );

      // Verify UI elements
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_filled_rounded), findsNothing);
      expect(find.text(AppStrings.nextLesson), findsOneWidget);
      expect(find.text('المفاصل والغضاريف'), findsOneWidget);
      expect(find.byType(AppForwardIcon), findsOneWidget);

      // Tap should trigger onLockedTap
      await tester.tap(find.byType(NextLessonButton));
      await tester.pump();

      expect(lockedTapCount, equals(1));
      expect(nextTapCount, equals(0));
    });

    testWidgets('2. Unlocked next lesson renders play icon and invokes onNextTap', (tester) async {
      var nextTapCount = 0;
      var lockedTapCount = 0;

      await tester.pumpWidget(
        _buildTestSubject(
          NextLessonButton(nextLesson: nextLesson, isUnlocked: true, onNextTap: () => nextTapCount++, onLockedTap: () => lockedTapCount++),
        ),
      );

      // Verify UI elements
      expect(find.byIcon(Icons.play_circle_filled_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      expect(find.text(AppStrings.nextLesson), findsOneWidget);
      expect(find.text('المفاصل والغضاريف'), findsOneWidget);
      expect(find.byType(AppForwardIcon), findsOneWidget);

      // Tap should trigger onNextTap
      await tester.tap(find.byType(NextLessonButton));
      await tester.pump();

      expect(nextTapCount, equals(1));
      expect(lockedTapCount, equals(0));
    });

    testWidgets('3. No next lesson (end of course) renders completion message', (tester) async {
      await tester.pumpWidget(_buildTestSubject(const NextLessonButton(nextLesson: null, isUnlocked: false)));

      // Verify UI elements
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.text(AppStrings.noNextLesson), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.play_circle_filled_rounded), findsNothing);
    });
  });
}
