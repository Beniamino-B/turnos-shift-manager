import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/paint_bar.dart';
import '../widgets/summary_card.dart';

const double _horizontalPadding = 12;
const double _summaryCardBottom = 104;
const double _paintBarBottom = 180;

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime? _lastPaintedDay;

  @override
  Widget build(BuildContext context) {
    final paintMode = ref.watch(paintModeProvider);
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const <Shift>[];
    final entries = ref.watch(entriesProvider).valueOrNull ?? const <DayEntry>[];

    final shiftsById = {for (final shift in shifts) shift.id: shift};
    final entriesByDay = {
      for (final entry in entries)
        DateTime(entry.date.year, entry.date.month, entry.date.day): entry,
    };

    final today = DateTime.now();
    final months = _monthWindow(today, 6, 12);

    return Stack(
      children: [
        Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _topBar(),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                physics: paintMode
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                slivers: [
                  for (final month in months)
                    _buildMonth(
                      month.$1,
                      month.$2,
                      entriesByDay,
                      shiftsById,
                      paintMode,
                      today,
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 200)),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: _summaryCardBottom,
          child: const SummaryCard(),
        ),
        if (paintMode)
          Positioned(
            left: 16,
            right: 16,
            bottom: _paintBarBottom,
            child: const PaintBar(),
          ),
      ],
    );
  }

  Widget _topBar() {
    final paintMode = ref.watch(paintModeProvider);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 26,
      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded,
              color: AppColors.primary, size: 26),
          const SizedBox(width: 10),
          const Text(
            'Calendario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          GlassIconButton(
            icon: paintMode
                ? Icons.close_rounded
                : Icons.brush_rounded,
            color: paintMode ? AppColors.danger : AppColors.textPrimary,
            onTap: _togglePaintMode,
            size: 42,
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: Icons.settings_rounded,
            onTap: () =>
                ref.read(currentTabProvider.notifier).state = 2,
            size: 42,
          ),
        ],
      ),
    );
  }

  void _togglePaintMode() {
    final paintMode = ref.read(paintModeProvider);
    if (paintMode) {
      ref.read(paintModeProvider.notifier).state = false;
      return;
    }
    final shifts = ref.read(shiftsProvider).valueOrNull ?? const <Shift>[];
    if (ref.read(activeShiftProvider) == null && shifts.isNotEmpty) {
      ref.read(activeShiftProvider.notifier).state = shifts.first.id;
    }
    ref.read(eraserActiveProvider.notifier).state = false;
    ref.read(paintModeProvider.notifier).state = true;
  }

  Widget _buildMonth(
    int year,
    int month,
    Map<DateTime, DayEntry> entriesByDay,
    Map<int, Shift> shiftsById,
    bool paintMode,
    DateTime today,
  ) {
    final cells = _monthCells(year, month);
    return SliverStickyHeader(
      header: _monthHeader(year, month),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = constraints.maxWidth / 7;
              final cellHeight = cellWidth / 0.9;
              final rows = (cells.length / 7).ceil();
              final gridHeight = rows * cellHeight;
              return SizedBox(
                height: gridHeight,
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: paintMode
                      ? (event) => _handlePaint(
                            event.localPosition,
                            cellWidth,
                            cellHeight,
                            cells,
                          )
                      : null,
                  onPointerMove: paintMode
                      ? (event) => _handlePaint(
                            event.localPosition,
                            cellWidth,
                            cellHeight,
                            cells,
                          )
                      : null,
                  onPointerUp: paintMode ? (_) => _lastPaintedDay = null : null,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: cells.length,
                    itemBuilder: (context, index) {
                      final date = cells[index];
                      if (date == null) {
                        return const SizedBox.shrink();
                      }
                      final entry = entriesByDay[date];
                      final shift =
                          entry == null ? null : shiftsById[entry.shiftId];
                      return _dayCell(date, shift, today);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handlePaint(
    Offset position,
    double cellWidth,
    double cellHeight,
    List<DateTime?> cells,
  ) {
    final column = (position.dx / cellWidth).floor();
    final row = (position.dy / cellHeight).floor();
    final index = row * 7 + column;
    if (index < 0 || index >= cells.length) return;

    final date = cells[index];
    if (date == null || _lastPaintedDay == date) return;
    _lastPaintedDay = date;

    final eraser = ref.read(eraserActiveProvider);
    final activeShift = ref.read(activeShiftProvider);
    if (!eraser && activeShift == null) return;

    final shiftId = eraser ? null : activeShift;
    unawaited(ref.read(paintDayProvider)(date, shiftId));
  }

  Widget _monthHeader(int year, int month) {
    return GlassContainer(
      borderRadius: 0,
      padding:
          const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
      color: Colors.white.withValues(alpha: 0.88),
      blur: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              formatMonthYear(DateTime(year, month, 1)),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Center(
                    child: Text(
                      spanishWeekdayInitials[i],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayCell(DateTime date, Shift? shift, DateTime today) {
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final shiftColor = shift == null ? null : colorFromHex(shift.colorHex);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: shiftColor == null
            ? Colors.transparent
            : shiftColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                color: isToday ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          if (shift != null) ...[
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: shiftColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                shift.abbreviation,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

List<DateTime?> _monthCells(int year, int month) {
  final first = DateTime(year, month, 1);
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final leading = first.weekday - 1;
  final cells = <DateTime?>[];
  for (var i = 0; i < leading; i++) {
    cells.add(null);
  }
  for (var day = 1; day <= daysInMonth; day++) {
    cells.add(DateTime(year, month, day));
  }
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return cells;
}

List<(int, int)> _monthWindow(DateTime today, int before, int after) {
  final result = <(int, int)>[];
  for (var offset = -before; offset <= after; offset++) {
    final monthIndex = today.month - 1 + offset;
    final year = today.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    result.add((year, month));
  }
  return result;
}
