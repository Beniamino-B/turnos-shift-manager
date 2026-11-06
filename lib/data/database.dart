import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get colorHex => text()();
  BoolColumn get isNightShift => boolean().withDefault(const Constant(false))();
  BoolColumn get isRestDay => boolean().withDefault(const Constant(false))();
  BoolColumn get appliesSundaySurcharge =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get appliesHolidaySurcharge =>
      boolean().withDefault(const Constant(true))();
}

class DayEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get shiftId => integer()
      .nullable()
      .references(Shifts, #id, onDelete: KeyAction.setNull)();
  TextColumn get note => text().withDefault(const Constant(''))();
}

class PayrollConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get baseSalary => integer()();
  BoolColumn get hasTransportAllowance =>
      boolean().withDefault(const Constant(false))();
  IntColumn get transportAllowanceAmount =>
      integer().withDefault(const Constant(0))();
  TextColumn get frequency => text().withDefault(const Constant('MONTHLY'))();
  IntColumn get cutoffDay1 => integer().withDefault(const Constant(1))();
  IntColumn get cutoffDay2 => integer().withDefault(const Constant(16))();
  IntColumn get paymentDay1 => integer().withDefault(const Constant(30))();
  IntColumn get paymentDay2 => integer().withDefault(const Constant(15))();
  IntColumn get healthPercentage => integer().withDefault(const Constant(4))();
  IntColumn get pensionPercentage => integer().withDefault(const Constant(4))();
  IntColumn get nightSurchargePercentage =>
      integer().withDefault(const Constant(35))();
  IntColumn get extraDaySurcharge => integer().withDefault(const Constant(75))();
}

class PaymentHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get expectedAmount => integer()();
  IntColumn get paidAmount => integer()();
  IntColumn get extraDeductions => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get onboardingDone => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
    tables: [Shifts, DayEntries, PayrollConfigs, PaymentHistory, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(shifts, shifts.isRestDay);
            await m.addColumn(shifts, shifts.appliesSundaySurcharge);
            await m.addColumn(shifts, shifts.appliesHolidaySurcharge);
            await m.addColumn(payrollConfigs, payrollConfigs.paymentDay1);
            await m.addColumn(payrollConfigs, payrollConfigs.paymentDay2);
            await m.createTable(appSettings);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'turnos.db'));
    return NativeDatabase.createInBackground(file);
  });
}

Future<void> seedDefaults(AppDatabase db) async {
  final shifts = await db.select(db.shifts).get();
  if (shifts.isEmpty) {
    await db.batch((batch) {
      batch.insertAll(db.shifts, [
        ShiftsCompanion.insert(
          name: 'Día',
          abbreviation: 'D',
          startTime: '06:00',
          endTime: '14:00',
          colorHex: '#5B5FEF',
        ),
        ShiftsCompanion.insert(
          name: 'Tarde',
          abbreviation: 'T',
          startTime: '14:00',
          endTime: '22:00',
          colorHex: '#FF9F43',
        ),
        ShiftsCompanion.insert(
          name: 'Noche',
          abbreviation: 'N',
          startTime: '22:00',
          endTime: '06:00',
          colorHex: '#7C3AED',
          isNightShift: const Value(true),
        ),
        ShiftsCompanion.insert(
          name: 'Descanso',
          abbreviation: 'L',
          startTime: '00:00',
          endTime: '00:00',
          colorHex: '#9CA3AF',
          isRestDay: const Value(true),
          appliesSundaySurcharge: const Value(false),
          appliesHolidaySurcharge: const Value(false),
        ),
      ]);
    });
  }

  final configs = await db.select(db.payrollConfigs).get();
  if (configs.isEmpty) {
    await db.into(db.payrollConfigs).insert(
          PayrollConfigsCompanion.insert(
            baseSalary: 130000000,
            hasTransportAllowance: const Value(true),
            transportAllowanceAmount: const Value(20000000),
            healthPercentage: const Value(4),
            pensionPercentage: const Value(4),
            nightSurchargePercentage: const Value(35),
            extraDaySurcharge: const Value(75),
          ),
        );
  }
}
