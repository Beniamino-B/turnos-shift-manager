import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/paint_bar.dart';

const double _horizontalPadding = 12;
const double _paintBarBottom = 100;

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _monthKeys = {};
  final Map<int, double> _monthBlur = {};
  DateTime? _lastPaintedDay;
  Timer? _hideTimer;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final delta = offset - _lastOffset;
    _lastOffset = offset;

    if (delta > 1) {
      ref.read(summaryVisibleProvider.notifier).state = false;
    } else if (delta < -1) {
      ref.read(summaryVisibleProvider.notifier).state = true;
    }

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(summaryVisibleProvider.notifier).state = true;
      }
    });

    _updateBlur();
  }

  void _updateBlur() {
    if (!mounted) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final center = screenHeight / 2;
    var changed = false;

    _monthKeys.forEach((index, key) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject();
      if (box is! RenderBox || !box.attached) return;
      final top = box.localToGlobal(Offset.zero).dy;
      final gridCenter = top + box.size.height / 2;
      final distance = (gridCenter - center).abs();
      final blur = (distance / screenHeight).clamp(0.0, 1.0) * 4.0;
      final prev = _monthBlur[index];
      if (prev == null || (prev - blur).abs() > 0.15) {
        _monthBlur[index] = blur;
        changed = true;
      }
    });

    if (changed) setState(() {});
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
    final months = _monthWindow(today, 6, 12);
    final bottomInset = MediaQuery.of(context).padding.bottom;

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
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: paintMode
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                slivers: [
                  for (var i = 0; i < months.length; i++)
                    _buildMonth(
                      months[i].$1,
                      months[i].$2,
                      entriesByDay,
                      shiftsById,
                      paintMode,
                      today,
                      i,
                      palette,
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 170)),
                ],
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

  Widget _buildMonth(
    int year,
    int month,
    Map<DateTime, DayEntry> entriesByDay,
    Map<int, Shift> shiftsById,
    bool paintMode,
    DateTime today,
    int index,
    AppPalette palette,
  ) {
    final cells = _monthCells(year, month);
    final key = _monthKeys.putIfAbsent(index, () => GlobalKey());
    final blur = _monthBlur[index] ?? 0.0;

    return SliverStickyHeader(
      header: _monthHeader(year, month, palette),
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
                key: key,
                height: gridHeight,
                child: ImageFiltered(
                  imageFilter:
                      ImageFilter.blur(sigmaX: blur, sigmaY: blur),
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
                    onPointerUp:
                        paintMode ? (_) => _lastPaintedDay = null : null,
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
                      itemBuilder: (context, cellIndex) {
                        final date = cells[cellIndex];
                        if (date == null) {
                          return const SizedBox.shrink();
                        }
                        final entry = entriesByDay[date];
                        final shift = entry == null
                            ? null
                            : shiftsById[entry.shiftId];
                        return _dayCell(date, shift, today, palette);
                      },
                    ),
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

  Widget _monthHeader(int year, int month, AppPalette palette) {
    return GlassContainer(
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding, vertical: 8),
      color: Colors.white.withValues(alpha: 0.88),
      blur: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              formatMonthYear(DateTime(year, month, 1)),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
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
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary,
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

  Widget _dayCell(DateTime date, Shift? shift, DateTime today, AppPalette palette) {
    final isToday = date.year == today.year &&
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
                color: isToday ? Colors.white : palette.textPrimary,
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
