import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/buttons/app_button.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson_note.dart';
import '../manager/player_cubit.dart';
import 'add_lesson_note_sheet.dart';
import 'lesson_note_item_tile.dart';

class LessonNotesCard extends StatefulWidget {
  const LessonNotesCard({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

  @override
  State<LessonNotesCard> createState() => _LessonNotesCardState();
}

class _LessonNotesCardState extends State<LessonNotesCard> {
  late final PlayerCubit _cubit;
  List<LessonNote> _notes = const [];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PlayerCubit>();
    _notes = _cubit.getLessonNotes(widget.lessonId);
  }

  void _onAddNotePressed() {
    AddLessonNoteSheet.show(
      context,
      onAddNote: (text) async {
        await _cubit.addLessonNote(lessonId: widget.lessonId, text: text);
        if (mounted) {
          setState(() {
            _notes = _cubit.getLessonNotes(widget.lessonId);
          });
        }
      },
    );
  }

  Future<void> _onDeleteNote(String noteId) async {
    await _cubit.deleteLessonNote(lessonId: widget.lessonId, noteId: noteId);
    if (mounted) {
      setState(() {
        _notes = _cubit.getLessonNotes(widget.lessonId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        AppStrings.lessonNotes,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_notes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_notes.length}',
                          style: AppTextStyles.caption.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                text: AppStrings.addNote,
                icon: const Icon(Icons.add_rounded, size: 16),
                variant: AppButtonVariant.secondary,
                height: 34,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: _onAddNotePressed,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_notes.isEmpty)
            InkWell(
              onTap: _onAddNotePressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 28,
                      color: colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.noNotesYet,
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final note = _notes[index];
                return LessonNoteItemTile(
                  note: note,
                  onDelete: () => _onDeleteNote(note.id),
                );
              },
            ),
        ],
      ),
    );
  }
}
