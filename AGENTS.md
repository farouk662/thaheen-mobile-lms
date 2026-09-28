# AI Agent Instructions — Thaheen LMS (Mobile Screening Task)

This document defines the conventions for the `thaheen_lms` project. Follow it for any
code generated in this repo.

## 0. What Makes This Project Different
- **Fully offline, permanently** — there is no backend, no networking layer at all.
  Don't add any `DioHelper`/`EndPoints`/API-error scaffolding.
- **Time-boxed (4–6 hours)** — every added abstraction has to earn its place.

## 1. Project Architecture
Feature-first, **no domain layer**.

```
lib/
  core/
    constants/
      app_keys.dart         // AppKeys — all Hive box, preference, and record keys
    extensions/
      build_context_extension.dart // BuildContext extensions (context.colorScheme, context.theme)
    theme/
      app_colors.dart       // AppColors — all Color constants
      app_text_styles.dart  // AppTextStyles — all TextStyle constants
    widgets/
      feedback/              AppErrorView, AppEmptyView, AppLoadingView
      cards/                  CourseCard, ContinueWatchingCard
      adaptive/               AppBackButton, AppForwardIcon
      buttons/                AppButton
      fields/                  AppTextField
    routing/
      app_router.dart        // AppRouter — GoRouter instance + route constants
    localization/
      app_strings.dart       // AppStrings — loads ar.json & en.json, typed getters + tr()
      locale_cubit.dart      // LocaleCubit — ar/en switch, persisted in Hive
    services/
      hive_service.dart      // opens the Hive box at startup
      get_it_service.dart    // setupGetItService() — see §4

  features/
    shared/
      data/
        models/               course.dart, course_section.dart, lesson.dart, lesson_note.dart
        datasources/
          courses_local_data_source.dart    // reads assets/data/courses.json
          progress_local_data_source.dart   // Hive read/write for position + completed
          notes_local_data_source.dart      // Hive read/write for lesson notes
        repositories/
          course_repository.dart            // combines datasources
      logic/
        progress_rules.dart    // pure Dart, ZERO Flutter imports — see §9

    courses/
      presentation/
        views/       courses_view.dart
        widgets/
        manager/     courses_cubit.dart, courses_state.dart

    course_details/
      presentation/
        views/       course_details_view.dart
        widgets/     lesson_tile.dart
        manager/     course_details_cubit.dart, course_details_state.dart

    player/
      presentation/
        views/       player_view.dart
        widgets/     speed_menu.dart, lesson_notes_card.dart
        manager/     player_cubit.dart, player_state.dart

test/
  features/
    shared/
      logic/
        progress_rules_test.dart
    course_details/
      presentation/
        widgets/
          lesson_tile_test.dart
    player/
      presentation/
        widgets/
          next_lesson_button_test.dart

assets/
  data/courses.json
  translations/
    ar.json                  // Arabic translations (default/primary)
    en.json                  // English translations
```

- **Don't** create a `network/` folder — there are no API calls anywhere in this app.
- **Do** place `Course`/`CourseSection`/`Lesson` models, the local datasources, and the
  repository in `features/shared/data/`, never in `core/` and never inside a single
  feature's own `data/` folder. No feature (`courses/`, `course_details/`, `player/`)
  may import a model from another feature's folder.

## 2. Naming Conventions
`snake_case` files, `PascalCase` classes, `camelCase` members.
- Views: `courses_view.dart` → `CoursesView`
- Cubits: `player_cubit.dart` / `player_state.dart` → `PlayerCubit` / `PlayerState`
- Widgets: `lesson_tile.dart` → `LessonTile`
- Models: `course.dart` → `Course` (plain model, no separate `Params`/`Entity` class)

## 3. State Management
`flutter_bloc` with Cubits, state as a sealed class hierarchy:

```dart
sealed class CoursesState {}
class CoursesInitial extends CoursesState {}
class CoursesLoading extends CoursesState {}
class CoursesLoaded extends CoursesState { final List<Course> courses; ... }
class CoursesEmpty extends CoursesState {}
class CoursesError extends CoursesState { final String message; }
```

- **Do** use Dart 3 `sealed class` + exhaustive `switch` in the view instead of
  `is`-checks where practical.
- **Do** keep any `TextEditingController`/`GlobalKey` owned, managed, and disposed by their
  respective `StatefulWidget` in the presentation layer. Cubits must deal strictly with pure
  business logic and primitive/domain state (e.g. `String query`).
- **Don't** use `dartz Either`/`Failure` — repository methods either return the data or
  throw a plain `AppException`, which the Cubit catches directly:
  ```dart
  try {
    final courses = await _repo.getCourses();
    emit(CoursesLoaded(courses));
  } on AppException catch (e) {
    emit(CoursesError(e.message));
  }
  ```

## 4. Dependency Injection — `get_it`
- **Do** register every datasource, repository, and Cubit in
  `lib/core/services/get_it_service.dart` inside `setupGetItService()`:
  ```dart
  final getIt = GetIt.instance;

  void setupGetItService() {
    // ── Services ─────────────────────────────────────────────
    getIt.registerLazySingleton<Box>(() => Hive.box(AppKeys.progressBox));

    // ── Data sources ─────────────────────────────────────────
    getIt.registerLazySingleton<CoursesLocalDataSource>(
      () => CoursesLocalDataSource(),
    );
    getIt.registerLazySingleton<ProgressLocalDataSource>(
      () => ProgressLocalDataSource(getIt<Box>()),
    );
    getIt.registerLazySingleton<NotesLocalDataSource>(
      () => NotesLocalDataSource(getIt<Box>()),
    );

    // ── Repositories ─────────────────────────────────────────
    getIt.registerLazySingleton<CourseRepository>(
      () => CourseRepository(getIt(), getIt(), getIt()),
    );

    // ── Cubits ───────────────────────────────────────────────
    getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt<Box>()));
    getIt.registerFactory<LocaleCubit>(() => LocaleCubit(getIt<Box>()));
    getIt.registerFactory<CoursesCubit>(
      () => CoursesCubit(getIt<CourseRepository>()),
    );
    getIt.registerFactory<CourseDetailsCubit>(
      () => CourseDetailsCubit(getIt<CourseRepository>()),
    );
    getIt.registerFactory<PlayerCubit>(
      () => PlayerCubit(getIt<CourseRepository>()),
    );
  }
  ```
- **Do** call `await HiveService.init()` (which opens the box) **before**
  `setupGetItService()` in `main()`, since the service registrations depend on the box
  already being open.
- **Do** provide Cubits to views through `getIt`, never instantiate directly:
  ```dart
  // ✅ Correct
  BlocProvider(
    create: (_) => getIt<CoursesCubit>()..loadCourses(),
    child: const Scaffold(
      appBar: CoursesAppBar(),
      body: CoursesViewBody(),
    ),
  )

  // ❌ Wrong
  BlocProvider(
    create: (_) => CoursesCubit(CourseRepository(...)),
    child: const Scaffold(
      appBar: CoursesAppBar(),
      body: CoursesViewBody(),
    ),
  )
  ```
- **Do** register repositories as `LazySingleton` and Cubits as `Factory` (a fresh
  instance per view push, disposed when `BlocProvider` is popped).

## 5. Models
- Place models in `features/shared/data/models/`. Use `fromJson(Map<String, dynamic>)`
  (not `fromMap`) since the only serialization source is `courses.json`, not an API.
- No `toJson()` needed for course/lesson catalog models — they're read-only. Progress
  records (position, completed, lastWatchedAt) do need `toJson()`/`fromJson()` for Hive.
- No domain `Entity` layer — the model *is* what the UI and the Cubit use.

## 6. Persistence (Hive) & Keys
- **Do** centralize all persistence keys in `lib/core/constants/app_keys.dart` (`AppKeys`):
  - Box names: `AppKeys.progressBox` (`'progress'`)
  - Preferences / setting keys: `AppKeys.localeCode` (`'locale_code'`), `AppKeys.themeMode` (`'theme_mode'`)
  - Progress record map keys: `AppKeys.positionSec`, `AppKeys.completed`, `AppKeys.lastWatchedAt`
- **Don't** use raw string literals or private string constants for box names, settings, or progress maps anywhere in cubits, services, or datasources — always reference `AppKeys`.
- One box, opened once in `hive_service.dart` at app start: `Hive.openBox(AppKeys.progressBox)`.
- Key: `lessonId` (String). Value: a map with `AppKeys.positionSec` (int), `AppKeys.completed` (bool), `AppKeys.lastWatchedAt` (int, epoch ms — used to derive "Continue watching").
- **Do** save position on a periodic `video_player` position listener **and** on
  `AppLifecycleState.paused`/`detached` — not only on screen `dispose()`, or a killed
  app loses progress.
- **Don't** put catalog data (course/lesson titles) in Hive — that always comes fresh
  from `courses.json`. Hive only ever stores *progress*.

## 7. Error Handling
No network, so no `DioException`/`ServerFailure`. Instead:

- Define one small `AppException(String message)` (in `logic/` or `data/`) for: missing
  JSON asset, malformed JSON, missing/corrupt video file.
- **Screen-level data load failure** (e.g. `courses.json` fails to parse) → `Error`
  state → render `AppErrorView(message, onRetry: ...)`. Never a raw `Text('Error')`, no
  red screen.
- **Empty state** (a course with 0 lessons) → its own `Empty` state → `AppEmptyView`,
  distinct from an error.
- **Video playback failure** (missing/corrupt file) → handle inside the player screen
  with `chewie`'s `errorBuilder`, showing a friendly Arabic message inline — don't crash
  or dead-end the screen.
- **Locked lesson tap** → not an error state at all, just a transient message
  ("أكمل الدرس السابق أولاً") via a plain `SnackBar` — no dedicated toast
  infrastructure needed for one message at this scope.

## 8. Localization & RTL
- Arabic is the primary and default locale. Don't build English-first and "mirror" it.
- **Do** store all translations in `assets/translations/ar.json` and `assets/translations/en.json`.
- **Do** load these translations through `AppStrings.init()` at app startup, providing
  synchronous, type-safe getters (`AppStrings.myCoursesTitle`, etc.) as well as key-based
  lookup (`AppStrings.tr(key)`).
- **Do** manage locale switching via `LocaleCubit` (persisted to the Hive `AppKeys.progressBox`
  under key `AppKeys.localeCode`), which updates `AppStrings.setLocale()` and triggers full UI rebuilds.
- **Don't** hardcode any user-facing string inline in a widget — always through
  `AppStrings`, even if you only ever ship Arabic.
- **RTL & Platform-Adaptive Navigation Rules:**
  - In any `Row(children: [...])` under RTL, `children[0]` renders on the **right**,
    the last child on the **left**. Order children as they appear in the design,
    right-to-left.
  - `CrossAxisAlignment.start` = right in RTL, `.end` = left. Use `.start` for
    right-aligned Arabic text/cards, not `.end`.
  - **Back navigation**: Use `AppBackButton` (from `lib/core/widgets/adaptive/app_back_button.dart`). Adapts to platform via `Theme.of(context).platform` (Material arrow on Android, Cupertino chevron on iOS) and points in the historical return direction (right `->` in RTL, left `<-` in LTR).
  - **Forward / Drill-down Affordances**:
    - Use `Icons.chevron_right_rounded` only for navigation affordances in cards, buttons, and list tiles (e.g. `CourseListTile`, `NextLessonButton`).
  - **Next Lesson Button**: Uses `Icons.play_circle_filled_rounded` when unlocked (`Icons.lock_outline_rounded` when locked) on the leading side, and `Icons.chevron_right_rounded` on the trailing side.
  - **Video Player Controls**: Center media controls (Rewind, Play/Pause, Fast-Forward) are wrapped in `Directionality.ltr` following universal media player standards (Rewind on left, Fast-Forward on right). The video seek bar tracks RTL visually in Arabic mode.

## 9. Testing Strategy
The test suite covers both domain progress calculations and core interactive widgets:
- **Logic Tests (`progress_rules_test.dart`)**:
  - `features/shared/logic/progress_rules.dart` must have **zero Flutter imports** — pure
    Dart functions only:
    - `bool isLessonCompleted(int watchedSec, int durationSec)` — true at ≥90%.
    - `bool isLessonUnlocked(int lessonIndex, List<String> completedLessonIds, List<Lesson> allLessons)`
    - `double courseProgressPercent(List<Lesson> allLessons, List<String> completedLessonIds)`
    - `int courseLessonCount(Course course)`
    - `double courseCompletionPercent(Course course, List<String> completedIds)`
  - `test/features/shared/logic/progress_rules_test.dart` — comprehensive edge cases, boundary testing (e.g. exactly 90% watched, cross-section unlock transition).
- **Widget Tests (`lesson_tile_test.dart`, `next_lesson_button_test.dart`)**:
  - Test core sequential progression in UI: Locked state, Completed state, and Available/In-progress state.
  - Setup rules for localized and themed widget tests:
    - Call `TestWidgetsFlutterBinding.ensureInitialized()` and `await AppStrings.init()` in `setUpAll`.
    - Wrap with `MaterialApp` specifying `locale: const Locale('ar')`, `supportedLocales`, `localizationsDelegates`, `theme`, and `Directionality.rtl`.
    - Use `const` constructors on test fixtures and models.

## 10. UI Conventions
- **View/Body split**: `CoursesView` (StatelessWidget, provides the Cubit via `getIt`, owns `Scaffold` + `AppBar`) →
  `CoursesViewBody` (owns `BlocBuilder`/`BlocConsumer` as the `Scaffold` `body`).
- **No private inner widget classes** and **no `_build...()` helper methods** — every
  widget, however small, gets its own file in the feature's `widgets/` folder.
- **Navigation**: `go_router` only, routes as `static const` on `AppRouter`. Use
  `context.push()` for drilling into a course/lesson, `context.go()` for resets.
- **Design tokens**: no hardcoded `Color(0xFF...)` or inline `TextStyle(...)` — use
  `AppColors`/`AppTextStyles`, kept intentionally small (6–8 colors, 4–5 text styles).
- **Theme Access**: Access `ColorScheme` via the extension getter `context.colorScheme` (from `lib/core/extensions/build_context_extension.dart`). For simple widgets (1–2 color usages), access inline as `context.colorScheme.<color>` without declaring a local variable. In complex widgets with multiple color usages, cache it as `final colorScheme = context.colorScheme;` — never abbreviate as `cs`, and never use `Theme.of(context).colorScheme`.
- **No `flutter_screenutil`** — a 2–3 screen app doesn't need responsive-scaling
  infrastructure; use plain `EdgeInsets`/`SizedBox` values and `MediaQuery` only where a
  layout genuinely needs to react to screen size (e.g. fullscreen video rotation).

## 11. Code Style
- `const` constructors wherever possible.
- Plain `debugPrint()` is fine for this scope — no dedicated `logger` service needed for
  a screening task this size.
- Keep files small; one widget class per file regardless of size.
