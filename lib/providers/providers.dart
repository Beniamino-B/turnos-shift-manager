import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
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

final appSettingsProvider = StreamProvider<AppSetting?>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.appSettings)..limit(1);
  return query.watch().map((rows) => rows.isEmpty ? null : rows.first);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsProvider).valueOrNull;
  switch (settings?.themeMode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
});

final onboardingDoneProvider = Provider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider).valueOrNull;
  return settings?.onboardingDone ?? false;
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
final summaryVisibleProvider = StateProvider<bool>((ref) => true);

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

final setThemeModeProvider =
    Provider<Future<void> Function(String mode)>((ref) {
  final db = ref.read(databaseProvider);
  return (mode) async {
    await _upsertSettings(db, AppSettingsCompanion(themeMode: Value(mode)));
  };
});

final completeOnboardingProvider = Provider<Future<void> Function()>((ref) {
  final db = ref.read(databaseProvider);
  return () async {
    await _upsertSettings(
        db, AppSettingsCompanion(onboardingDone: const Value(true)));
  };
});

Future<void> _upsertSettings(AppDatabase db, AppSettingsCompanion companion) {
  return db.transaction(() async {
    final existing = await (db.select(db.appSettings)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await db.into(db.appSettings).insert(companion);
    } else {
      await (db.update(db.appSettings)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
    }
  });
}
