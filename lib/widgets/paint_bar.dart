import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import 'glass.dart';

class PaintBar extends ConsumerWidget {
  const PaintBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const [];
    final eraserActive = ref.watch(eraserActiveProvider);
    final activeShift = ref.watch(activeShiftProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.brush_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              const Text(
                'Modo pintura',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              _EraserButton(
                active: eraserActive,
                onTap: () {
                  ref.read(eraserActiveProvider.notifier).state = true;
                  ref.read(activeShiftProvider.notifier).state = null;
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shifts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final shift = shifts[index];
                final selected =
                    !eraserActive && activeShift == shift.id;
                return _ShiftPill(
                  shift: shift,
                  selected: selected,
                  onTap: () {
                    ref.read(activeShiftProvider.notifier).state = shift.id;
                    ref.read(eraserActiveProvider.notifier).state = false;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftPill extends StatelessWidget {
  final Shift shift;
  final bool selected;
  final VoidCallback onTap;

  const _ShiftPill({
    required this.shift,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(shift.colorHex);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.white.withValues(alpha: 0.8),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: selected ? Colors.white : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              shift.abbreviation,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EraserButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _EraserButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.danger
              : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        ),
        child: Icon(
          Icons.auto_fix_off_rounded,
          color: active ? Colors.white : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}
