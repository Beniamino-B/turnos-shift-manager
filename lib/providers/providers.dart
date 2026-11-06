import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/payroll_engine.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final shiftsProvider = StreamProvider<List<Shift>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.shifts).watch();
});

final entriesProvider = StreamProvider<List<DayEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.dayEntries).watch();
});

final configProvider = StreamProvider<PayrollConfig?>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.payrollConfigs)..limit(1);
  return query.watch().map((rows) => rows.isEmpty ? null : rows.first);
});

final paymentHistoryProvider = StreamProvider<List<PaymentHistoryData>>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.paymentHistory)
    ..orderBy([(t) => OrderingTerm.desc(t.periodStart)]);
  return query.watch();
});

final payrollSummaryProvider = Provider<PayrollSummary?>((ref) {
  final config = ref.watch(configProvider).valueOrNull;
  final shifts = ref.watch(shiftsProvider).valueOrNull;
  final entries = ref.watch(entriesProvider).valueOrNull;
  if (config == null || shifts == null || entries == null) return null;

  final now = DateTime.now();
  final (periodStart, periodEnd) = currentPeriod(config, now);
  return computePayroll(
    shifts: shifts,
    entries: entries,
    config: config,
    periodStart: periodStart,
    periodEnd: periodEnd,
    now: now,
    extraDeductions: 0,
  );
});

final paintModeProvider = StateProvider<bool>((ref) => false);
final activeShiftProvider = StateProvider<int?>((ref) => null);
final eraserActiveProvider = StateProvider<bool>((ref) => false);
final currentTabProvider = StateProvider<int>((ref) => 0);

final paintDayProvider =
    Provider<Future<void> Function(DateTime date, int? shiftId)>((ref) {
  final db = ref.read(databaseProvider);
  return (date, shiftId) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final existing = await (db.select(db.dayEntries)
          ..where((t) => t.date.equals(normalized)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.dayEntries).insert(
            DayEntriesCompanion.insert(
              date: normalized,
              shiftId: Value(shiftId),
            ),
          );
    } else {
      await (db.update(db.dayEntries)
            ..where((t) => t.id.equals(existing.id)))
          .write(DayEntriesCompanion(shiftId: Value(shiftId)));
    }
  };
});
