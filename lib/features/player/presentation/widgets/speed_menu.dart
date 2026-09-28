import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';

class SpeedMenu extends StatelessWidget {
  const SpeedMenu({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  final double currentSpeed;
  final ValueChanged<double> onSpeedSelected;

  static const List<double> availableSpeeds = [1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.playbackSpeed,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: availableSpeeds.map((speed) {
              final isSelected = (speed - currentSpeed).abs() < 0.01;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : colorScheme.primary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                            ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => onSpeedSelected(speed),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: Text(
                            '${speed == 1.0 ? '1' : speed.toString()}x',
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
