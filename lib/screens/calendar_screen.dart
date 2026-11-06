import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/paint_bar.dart';

const double _horizontalPadding = 14;
const double _bottomPadding = kBottomNavHeight + 80;
const double _paintBarBottom = 100;

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final PageController _pageController;
  late final List<(int, int)> _months;
  late int _currentPage;
  DateTime? _lastPaintedDay;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final startYear = today.year - 2;
    _months = [
      for (var y = startYear; y <= startYear + 4; y++)
        for (var m = 1; m <= 12; m++) (y, m),
    ];
    _currentPage = (today.year - startYear) * 12 + (today.month - 1);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final paintMode = ref.watch(paintModeProvider);
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const <Shift>[];
    final entries = ref.watch(entriesProvider).valueOrNull ?? const <DayEntry>[];

    final shiftsById = {for (final shift in shifts) shift.id: shift};
    final entriesByDay = {
      for (final entry in entries)
        DateTime(entry.date.year, entry.date.month, entry.date.day): entry,
    };

    final today = DateTime.now();
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final (year, month) = _months[_currentPage];

    return Stack(
      children: [
        Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _topBar(palette),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                formatMonthYear(DateTime(year, month, 1)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: _bottomPadding),
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: paintMode
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                    return _monthPage(
                      _months[index].$1,
                      _months[index].$2,
                      entriesByDay,
                      shiftsById,
                      paintMode,
                      today,
                      palette,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        if (paintMode)
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset + _paintBarBottom,
            child: const PaintBar(),
          ),
      ],
    );
  }

  Widget _topBar(AppPalette palette) {
    final paintMode = ref.watch(paintModeProvider);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 26,
      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded,
              color: AppColors.primary, size: 26),
          const SizedBox(width: 10),
          Text(
            'Calendario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const Spacer(),
          GlassIconButton(
            icon: paintMode ? Icons.close_rounded : Icons.brush_rounded,
            color: paintMode ? AppColors.danger : palette.textPrimary,
            onTap: _togglePaintMode,
            size: 42,
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: Icons.settings_rounded,
            onTap: () => ref.read(currentTabProvider.notifier).state = 2,
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
      ref.read(summaryVisibleProvider.notifier).state = true;
      return;
    }
    final shifts = ref.read(shiftsProvider).valueOrNull ?? const <Shift>[];
    if (ref.read(activeShiftProvider) == null && shifts.isNotEmpty) {
      ref.read(activeShiftProvider.notifier).state = shifts.first.id;
    }
    ref.read(eraserActiveProvider.notifier).state = false;
    ref.read(summaryVisibleProvider.notifier).state = false;
    ref.read(paintModeProvider.notifier).state = true;
  }

  Widget _monthPage(
    int year,
    int month,
    Map<DateTime, DayEntry> entriesByDay,
    Map<int, Shift> shiftsById,
    bool paintMode,
    DateTime today,
    AppPalette palette,
  ) {
    final cells = _monthCells(year, month);
    return Column(
      children: [
        _weekdayRow(palette),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final rows = cells.length ~/ 7;
                final cellWidth = constraints.maxWidth / 7;
                final cellHeight = constraints.maxHeight / rows;
                return Listener(
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
                  onPointerUp:
                      paintMode ? (_) => _lastPaintedDay = null : null,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: cellWidth / cellHeight,
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
                      return _dayCell(date, shift, today, palette);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _weekdayRow(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(
                  spanishWeekdayInitials[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            ),
        ],
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

  Widget _dayCell(DateTime date, Shift? shift, DateTime today, AppPalette palette) {
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final shiftColor = shift == null ? null : colorFromHex(shift.colorHex);

    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: shiftColor == null
            ? Colors.transparent
            : shiftColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                color: isToday ? Colors.white : palette.textPrimary,
              ),
            ),
          ),
          if (shift != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: shiftColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                shift.abbreviation,
                style: const TextStyle(
                  fontSize: 10,
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
