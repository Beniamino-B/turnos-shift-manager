// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _abbreviationMeta =
      const VerificationMeta('abbreviation');
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
      'abbreviation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isNightShiftMeta =
      const VerificationMeta('isNightShift');
  @override
  late final GeneratedColumn<bool> isNightShift = GeneratedColumn<bool>(
      'is_night_shift', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_night_shift" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, abbreviation, startTime, endTime, colorHex, isNightShift];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<Shift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
          _abbreviationMeta,
          abbreviation.isAcceptableOrUnknown(
              data['abbreviation']!, _abbreviationMeta));
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_night_shift')) {
      context.handle(
          _isNightShiftMeta,
          isNightShift.isAcceptableOrUnknown(
              data['is_night_shift']!, _isNightShiftMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      abbreviation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbreviation'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      isNightShift: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_night_shift'])!,
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final int id;
  final String name;
  final String abbreviation;
  final String startTime;
  final String endTime;
  final String colorHex;
  final bool isNightShift;
  const Shift(
      {required this.id,
      required this.name,
      required this.abbreviation,
      required this.startTime,
      required this.endTime,
      required this.colorHex,
      required this.isNightShift});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_night_shift'] = Variable<bool>(isNightShift);
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      name: Value(name),
      abbreviation: Value(abbreviation),
      startTime: Value(startTime),
      endTime: Value(endTime),
      colorHex: Value(colorHex),
      isNightShift: Value(isNightShift),
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isNightShift: serializer.fromJson<bool>(json['isNightShift']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'colorHex': serializer.toJson<String>(colorHex),
      'isNightShift': serializer.toJson<bool>(isNightShift),
    };
  }

  Shift copyWith(
          {int? id,
          String? name,
          String? abbreviation,
          String? startTime,
          String? endTime,
          String? colorHex,
          bool? isNightShift}) =>
      Shift(
        id: id ?? this.id,
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        colorHex: colorHex ?? this.colorHex,
        isNightShift: isNightShift ?? this.isNightShift,
      );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isNightShift: data.isNightShift.present
          ? data.isNightShift.value
          : this.isNightShift,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('colorHex: $colorHex, ')
          ..write('isNightShift: $isNightShift')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, abbreviation, startTime, endTime, colorHex, isNightShift);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.colorHex == this.colorHex &&
          other.isNightShift == this.isNightShift);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String> colorHex;
  final Value<bool> isNightShift;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isNightShift = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String abbreviation,
    required String startTime,
    required String endTime,
    required String colorHex,
    this.isNightShift = const Value.absent(),
  })  : name = Value(name),
        abbreviation = Value(abbreviation),
        startTime = Value(startTime),
        endTime = Value(endTime),
        colorHex = Value(colorHex);
  static Insertable<Shift> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? colorHex,
    Expression<bool>? isNightShift,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (colorHex != null) 'color_hex': colorHex,
      if (isNightShift != null) 'is_night_shift': isNightShift,
    });
  }

  ShiftsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? abbreviation,
      Value<String>? startTime,
      Value<String>? endTime,
      Value<String>? colorHex,
      Value<bool>? isNightShift}) {
    return ShiftsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      colorHex: colorHex ?? this.colorHex,
      isNightShift: isNightShift ?? this.isNightShift,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isNightShift.present) {
      map['is_night_shift'] = Variable<bool>(isNightShift.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('colorHex: $colorHex, ')
          ..write('isNightShift: $isNightShift')
          ..write(')'))
        .toString();
  }
}

class $DayEntriesTable extends DayEntries
    with TableInfo<$DayEntriesTable, DayEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES shifts (id) ON DELETE SET NULL'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, date, shiftId, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DayEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
    );
  }

  @override
  $DayEntriesTable createAlias(String alias) {
    return $DayEntriesTable(attachedDatabase, alias);
  }
}

class DayEntry extends DataClass implements Insertable<DayEntry> {
  final int id;
  final DateTime date;
  final int? shiftId;
  final String note;
  const DayEntry(
      {required this.id, required this.date, this.shiftId, required this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  DayEntriesCompanion toCompanion(bool nullToAbsent) {
    return DayEntriesCompanion(
      id: Value(id),
      date: Value(date),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      note: Value(note),
    );
  }

  factory DayEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'shiftId': serializer.toJson<int?>(shiftId),
      'note': serializer.toJson<String>(note),
    };
  }

  DayEntry copyWith(
          {int? id,
          DateTime? date,
          Value<int?> shiftId = const Value.absent(),
          String? note}) =>
      DayEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        note: note ?? this.note,
      );
  DayEntry copyWithCompanion(DayEntriesCompanion data) {
    return DayEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('shiftId: $shiftId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, shiftId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.shiftId == this.shiftId &&
          other.note == this.note);
}

class DayEntriesCompanion extends UpdateCompanion<DayEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> shiftId;
  final Value<String> note;
  const DayEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.note = const Value.absent(),
  });
  DayEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.shiftId = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DayEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? shiftId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (shiftId != null) 'shift_id': shiftId,
      if (note != null) 'note': note,
    });
  }

  DayEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int?>? shiftId,
      Value<String>? note}) {
    return DayEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      shiftId: shiftId ?? this.shiftId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('shiftId: $shiftId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $PayrollConfigsTable extends PayrollConfigs
    with TableInfo<$PayrollConfigsTable, PayrollConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _baseSalaryMeta =
      const VerificationMeta('baseSalary');
  @override
  late final GeneratedColumn<int> baseSalary = GeneratedColumn<int>(
      'base_salary', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hasTransportAllowanceMeta =
      const VerificationMeta('hasTransportAllowance');
  @override
  late final GeneratedColumn<bool> hasTransportAllowance =
      GeneratedColumn<bool>('has_transport_allowance', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("has_transport_allowance" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _transportAllowanceAmountMeta =
      const VerificationMeta('transportAllowanceAmount');
  @override
  late final GeneratedColumn<int> transportAllowanceAmount =
      GeneratedColumn<int>('transport_allowance_amount', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('MONTHLY'));
  static const VerificationMeta _cutoffDay1Meta =
      const VerificationMeta('cutoffDay1');
  @override
  late final GeneratedColumn<int> cutoffDay1 = GeneratedColumn<int>(
      'cutoff_day1', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _cutoffDay2Meta =
      const VerificationMeta('cutoffDay2');
  @override
  late final GeneratedColumn<int> cutoffDay2 = GeneratedColumn<int>(
      'cutoff_day2', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(16));
  static const VerificationMeta _healthPercentageMeta =
      const VerificationMeta('healthPercentage');
  @override
  late final GeneratedColumn<int> healthPercentage = GeneratedColumn<int>(
      'health_percentage', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _pensionPercentageMeta =
      const VerificationMeta('pensionPercentage');
  @override
  late final GeneratedColumn<int> pensionPercentage = GeneratedColumn<int>(
      'pension_percentage', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _nightSurchargePercentageMeta =
      const VerificationMeta('nightSurchargePercentage');
  @override
  late final GeneratedColumn<int> nightSurchargePercentage =
      GeneratedColumn<int>('night_surcharge_percentage', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(35));
  static const VerificationMeta _extraDaySurchargeMeta =
      const VerificationMeta('extraDaySurcharge');
  @override
  late final GeneratedColumn<int> extraDaySurcharge = GeneratedColumn<int>(
      'extra_day_surcharge', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(75));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        baseSalary,
        hasTransportAllowance,
        transportAllowanceAmount,
        frequency,
        cutoffDay1,
        cutoffDay2,
        healthPercentage,
        pensionPercentage,
        nightSurchargePercentage,
        extraDaySurcharge
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_configs';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_salary')) {
      context.handle(
          _baseSalaryMeta,
          baseSalary.isAcceptableOrUnknown(
              data['base_salary']!, _baseSalaryMeta));
    } else if (isInserting) {
      context.missing(_baseSalaryMeta);
    }
    if (data.containsKey('has_transport_allowance')) {
      context.handle(
          _hasTransportAllowanceMeta,
          hasTransportAllowance.isAcceptableOrUnknown(
              data['has_transport_allowance']!, _hasTransportAllowanceMeta));
    }
    if (data.containsKey('transport_allowance_amount')) {
      context.handle(
          _transportAllowanceAmountMeta,
          transportAllowanceAmount.isAcceptableOrUnknown(
              data['transport_allowance_amount']!,
              _transportAllowanceAmountMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('cutoff_day1')) {
      context.handle(
          _cutoffDay1Meta,
          cutoffDay1.isAcceptableOrUnknown(
              data['cutoff_day1']!, _cutoffDay1Meta));
    }
    if (data.containsKey('cutoff_day2')) {
      context.handle(
          _cutoffDay2Meta,
          cutoffDay2.isAcceptableOrUnknown(
              data['cutoff_day2']!, _cutoffDay2Meta));
    }
    if (data.containsKey('health_percentage')) {
      context.handle(
          _healthPercentageMeta,
          healthPercentage.isAcceptableOrUnknown(
              data['health_percentage']!, _healthPercentageMeta));
    }
    if (data.containsKey('pension_percentage')) {
      context.handle(
          _pensionPercentageMeta,
          pensionPercentage.isAcceptableOrUnknown(
              data['pension_percentage']!, _pensionPercentageMeta));
    }
    if (data.containsKey('night_surcharge_percentage')) {
      context.handle(
          _nightSurchargePercentageMeta,
          nightSurchargePercentage.isAcceptableOrUnknown(
              data['night_surcharge_percentage']!,
              _nightSurchargePercentageMeta));
    }
    if (data.containsKey('extra_day_surcharge')) {
      context.handle(
          _extraDaySurchargeMeta,
          extraDaySurcharge.isAcceptableOrUnknown(
              data['extra_day_surcharge']!, _extraDaySurchargeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayrollConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      baseSalary: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_salary'])!,
      hasTransportAllowance: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}has_transport_allowance'])!,
      transportAllowanceAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}transport_allowance_amount'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      cutoffDay1: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cutoff_day1'])!,
      cutoffDay2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cutoff_day2'])!,
      healthPercentage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}health_percentage'])!,
      pensionPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}pension_percentage'])!,
      nightSurchargePercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}night_surcharge_percentage'])!,
      extraDaySurcharge: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}extra_day_surcharge'])!,
    );
  }

  @override
  $PayrollConfigsTable createAlias(String alias) {
    return $PayrollConfigsTable(attachedDatabase, alias);
  }
}

class PayrollConfig extends DataClass implements Insertable<PayrollConfig> {
  final int id;
  final int baseSalary;
  final bool hasTransportAllowance;
  final int transportAllowanceAmount;
  final String frequency;
  final int cutoffDay1;
  final int cutoffDay2;
  final int healthPercentage;
  final int pensionPercentage;
  final int nightSurchargePercentage;
  final int extraDaySurcharge;
  const PayrollConfig(
      {required this.id,
      required this.baseSalary,
      required this.hasTransportAllowance,
      required this.transportAllowanceAmount,
      required this.frequency,
      required this.cutoffDay1,
      required this.cutoffDay2,
      required this.healthPercentage,
      required this.pensionPercentage,
      required this.nightSurchargePercentage,
      required this.extraDaySurcharge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_salary'] = Variable<int>(baseSalary);
    map['has_transport_allowance'] = Variable<bool>(hasTransportAllowance);
    map['transport_allowance_amount'] = Variable<int>(transportAllowanceAmount);
    map['frequency'] = Variable<String>(frequency);
    map['cutoff_day1'] = Variable<int>(cutoffDay1);
    map['cutoff_day2'] = Variable<int>(cutoffDay2);
    map['health_percentage'] = Variable<int>(healthPercentage);
    map['pension_percentage'] = Variable<int>(pensionPercentage);
    map['night_surcharge_percentage'] = Variable<int>(nightSurchargePercentage);
    map['extra_day_surcharge'] = Variable<int>(extraDaySurcharge);
    return map;
  }

  PayrollConfigsCompanion toCompanion(bool nullToAbsent) {
    return PayrollConfigsCompanion(
      id: Value(id),
      baseSalary: Value(baseSalary),
      hasTransportAllowance: Value(hasTransportAllowance),
      transportAllowanceAmount: Value(transportAllowanceAmount),
      frequency: Value(frequency),
      cutoffDay1: Value(cutoffDay1),
      cutoffDay2: Value(cutoffDay2),
      healthPercentage: Value(healthPercentage),
      pensionPercentage: Value(pensionPercentage),
      nightSurchargePercentage: Value(nightSurchargePercentage),
      extraDaySurcharge: Value(extraDaySurcharge),
    );
  }

  factory PayrollConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollConfig(
      id: serializer.fromJson<int>(json['id']),
      baseSalary: serializer.fromJson<int>(json['baseSalary']),
      hasTransportAllowance:
          serializer.fromJson<bool>(json['hasTransportAllowance']),
      transportAllowanceAmount:
          serializer.fromJson<int>(json['transportAllowanceAmount']),
      frequency: serializer.fromJson<String>(json['frequency']),
      cutoffDay1: serializer.fromJson<int>(json['cutoffDay1']),
      cutoffDay2: serializer.fromJson<int>(json['cutoffDay2']),
      healthPercentage: serializer.fromJson<int>(json['healthPercentage']),
      pensionPercentage: serializer.fromJson<int>(json['pensionPercentage']),
      nightSurchargePercentage:
          serializer.fromJson<int>(json['nightSurchargePercentage']),
      extraDaySurcharge: serializer.fromJson<int>(json['extraDaySurcharge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseSalary': serializer.toJson<int>(baseSalary),
      'hasTransportAllowance': serializer.toJson<bool>(hasTransportAllowance),
      'transportAllowanceAmount':
          serializer.toJson<int>(transportAllowanceAmount),
      'frequency': serializer.toJson<String>(frequency),
      'cutoffDay1': serializer.toJson<int>(cutoffDay1),
      'cutoffDay2': serializer.toJson<int>(cutoffDay2),
      'healthPercentage': serializer.toJson<int>(healthPercentage),
      'pensionPercentage': serializer.toJson<int>(pensionPercentage),
      'nightSurchargePercentage':
          serializer.toJson<int>(nightSurchargePercentage),
      'extraDaySurcharge': serializer.toJson<int>(extraDaySurcharge),
    };
  }

  PayrollConfig copyWith(
          {int? id,
          int? baseSalary,
          bool? hasTransportAllowance,
          int? transportAllowanceAmount,
          String? frequency,
          int? cutoffDay1,
          int? cutoffDay2,
          int? healthPercentage,
          int? pensionPercentage,
          int? nightSurchargePercentage,
          int? extraDaySurcharge}) =>
      PayrollConfig(
        id: id ?? this.id,
        baseSalary: baseSalary ?? this.baseSalary,
        hasTransportAllowance:
            hasTransportAllowance ?? this.hasTransportAllowance,
        transportAllowanceAmount:
            transportAllowanceAmount ?? this.transportAllowanceAmount,
        frequency: frequency ?? this.frequency,
        cutoffDay1: cutoffDay1 ?? this.cutoffDay1,
        cutoffDay2: cutoffDay2 ?? this.cutoffDay2,
        healthPercentage: healthPercentage ?? this.healthPercentage,
        pensionPercentage: pensionPercentage ?? this.pensionPercentage,
        nightSurchargePercentage:
            nightSurchargePercentage ?? this.nightSurchargePercentage,
        extraDaySurcharge: extraDaySurcharge ?? this.extraDaySurcharge,
      );
  PayrollConfig copyWithCompanion(PayrollConfigsCompanion data) {
    return PayrollConfig(
      id: data.id.present ? data.id.value : this.id,
      baseSalary:
          data.baseSalary.present ? data.baseSalary.value : this.baseSalary,
      hasTransportAllowance: data.hasTransportAllowance.present
          ? data.hasTransportAllowance.value
          : this.hasTransportAllowance,
      transportAllowanceAmount: data.transportAllowanceAmount.present
          ? data.transportAllowanceAmount.value
          : this.transportAllowanceAmount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      cutoffDay1:
          data.cutoffDay1.present ? data.cutoffDay1.value : this.cutoffDay1,
      cutoffDay2:
          data.cutoffDay2.present ? data.cutoffDay2.value : this.cutoffDay2,
      healthPercentage: data.healthPercentage.present
          ? data.healthPercentage.value
          : this.healthPercentage,
      pensionPercentage: data.pensionPercentage.present
          ? data.pensionPercentage.value
          : this.pensionPercentage,
      nightSurchargePercentage: data.nightSurchargePercentage.present
          ? data.nightSurchargePercentage.value
          : this.nightSurchargePercentage,
      extraDaySurcharge: data.extraDaySurcharge.present
          ? data.extraDaySurcharge.value
          : this.extraDaySurcharge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollConfig(')
          ..write('id: $id, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('hasTransportAllowance: $hasTransportAllowance, ')
          ..write('transportAllowanceAmount: $transportAllowanceAmount, ')
          ..write('frequency: $frequency, ')
          ..write('cutoffDay1: $cutoffDay1, ')
          ..write('cutoffDay2: $cutoffDay2, ')
          ..write('healthPercentage: $healthPercentage, ')
          ..write('pensionPercentage: $pensionPercentage, ')
          ..write('nightSurchargePercentage: $nightSurchargePercentage, ')
          ..write('extraDaySurcharge: $extraDaySurcharge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      baseSalary,
      hasTransportAllowance,
      transportAllowanceAmount,
      frequency,
      cutoffDay1,
      cutoffDay2,
      healthPercentage,
      pensionPercentage,
      nightSurchargePercentage,
      extraDaySurcharge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollConfig &&
          other.id == this.id &&
          other.baseSalary == this.baseSalary &&
          other.hasTransportAllowance == this.hasTransportAllowance &&
          other.transportAllowanceAmount == this.transportAllowanceAmount &&
          other.frequency == this.frequency &&
          other.cutoffDay1 == this.cutoffDay1 &&
          other.cutoffDay2 == this.cutoffDay2 &&
          other.healthPercentage == this.healthPercentage &&
          other.pensionPercentage == this.pensionPercentage &&
          other.nightSurchargePercentage == this.nightSurchargePercentage &&
          other.extraDaySurcharge == this.extraDaySurcharge);
}

class PayrollConfigsCompanion extends UpdateCompanion<PayrollConfig> {
  final Value<int> id;
  final Value<int> baseSalary;
  final Value<bool> hasTransportAllowance;
  final Value<int> transportAllowanceAmount;
  final Value<String> frequency;
  final Value<int> cutoffDay1;
  final Value<int> cutoffDay2;
  final Value<int> healthPercentage;
  final Value<int> pensionPercentage;
  final Value<int> nightSurchargePercentage;
  final Value<int> extraDaySurcharge;
  const PayrollConfigsCompanion({
    this.id = const Value.absent(),
    this.baseSalary = const Value.absent(),
    this.hasTransportAllowance = const Value.absent(),
    this.transportAllowanceAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.cutoffDay1 = const Value.absent(),
    this.cutoffDay2 = const Value.absent(),
    this.healthPercentage = const Value.absent(),
    this.pensionPercentage = const Value.absent(),
    this.nightSurchargePercentage = const Value.absent(),
    this.extraDaySurcharge = const Value.absent(),
  });
  PayrollConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int baseSalary,
    this.hasTransportAllowance = const Value.absent(),
    this.transportAllowanceAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.cutoffDay1 = const Value.absent(),
    this.cutoffDay2 = const Value.absent(),
    this.healthPercentage = const Value.absent(),
    this.pensionPercentage = const Value.absent(),
    this.nightSurchargePercentage = const Value.absent(),
    this.extraDaySurcharge = const Value.absent(),
  }) : baseSalary = Value(baseSalary);
  static Insertable<PayrollConfig> custom({
    Expression<int>? id,
    Expression<int>? baseSalary,
    Expression<bool>? hasTransportAllowance,
    Expression<int>? transportAllowanceAmount,
    Expression<String>? frequency,
    Expression<int>? cutoffDay1,
    Expression<int>? cutoffDay2,
    Expression<int>? healthPercentage,
    Expression<int>? pensionPercentage,
    Expression<int>? nightSurchargePercentage,
    Expression<int>? extraDaySurcharge,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseSalary != null) 'base_salary': baseSalary,
      if (hasTransportAllowance != null)
        'has_transport_allowance': hasTransportAllowance,
      if (transportAllowanceAmount != null)
        'transport_allowance_amount': transportAllowanceAmount,
      if (frequency != null) 'frequency': frequency,
      if (cutoffDay1 != null) 'cutoff_day1': cutoffDay1,
      if (cutoffDay2 != null) 'cutoff_day2': cutoffDay2,
      if (healthPercentage != null) 'health_percentage': healthPercentage,
      if (pensionPercentage != null) 'pension_percentage': pensionPercentage,
      if (nightSurchargePercentage != null)
        'night_surcharge_percentage': nightSurchargePercentage,
      if (extraDaySurcharge != null) 'extra_day_surcharge': extraDaySurcharge,
    });
  }

  PayrollConfigsCompanion copyWith(
      {Value<int>? id,
      Value<int>? baseSalary,
      Value<bool>? hasTransportAllowance,
      Value<int>? transportAllowanceAmount,
      Value<String>? frequency,
      Value<int>? cutoffDay1,
      Value<int>? cutoffDay2,
      Value<int>? healthPercentage,
      Value<int>? pensionPercentage,
      Value<int>? nightSurchargePercentage,
      Value<int>? extraDaySurcharge}) {
    return PayrollConfigsCompanion(
      id: id ?? this.id,
      baseSalary: baseSalary ?? this.baseSalary,
      hasTransportAllowance:
          hasTransportAllowance ?? this.hasTransportAllowance,
      transportAllowanceAmount:
          transportAllowanceAmount ?? this.transportAllowanceAmount,
      frequency: frequency ?? this.frequency,
      cutoffDay1: cutoffDay1 ?? this.cutoffDay1,
      cutoffDay2: cutoffDay2 ?? this.cutoffDay2,
      healthPercentage: healthPercentage ?? this.healthPercentage,
      pensionPercentage: pensionPercentage ?? this.pensionPercentage,
      nightSurchargePercentage:
          nightSurchargePercentage ?? this.nightSurchargePercentage,
      extraDaySurcharge: extraDaySurcharge ?? this.extraDaySurcharge,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseSalary.present) {
      map['base_salary'] = Variable<int>(baseSalary.value);
    }
    if (hasTransportAllowance.present) {
      map['has_transport_allowance'] =
          Variable<bool>(hasTransportAllowance.value);
    }
    if (transportAllowanceAmount.present) {
      map['transport_allowance_amount'] =
          Variable<int>(transportAllowanceAmount.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (cutoffDay1.present) {
      map['cutoff_day1'] = Variable<int>(cutoffDay1.value);
    }
    if (cutoffDay2.present) {
      map['cutoff_day2'] = Variable<int>(cutoffDay2.value);
    }
    if (healthPercentage.present) {
      map['health_percentage'] = Variable<int>(healthPercentage.value);
    }
    if (pensionPercentage.present) {
      map['pension_percentage'] = Variable<int>(pensionPercentage.value);
    }
    if (nightSurchargePercentage.present) {
      map['night_surcharge_percentage'] =
          Variable<int>(nightSurchargePercentage.value);
    }
    if (extraDaySurcharge.present) {
      map['extra_day_surcharge'] = Variable<int>(extraDaySurcharge.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollConfigsCompanion(')
          ..write('id: $id, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('hasTransportAllowance: $hasTransportAllowance, ')
          ..write('transportAllowanceAmount: $transportAllowanceAmount, ')
          ..write('frequency: $frequency, ')
          ..write('cutoffDay1: $cutoffDay1, ')
          ..write('cutoffDay2: $cutoffDay2, ')
          ..write('healthPercentage: $healthPercentage, ')
          ..write('pensionPercentage: $pensionPercentage, ')
          ..write('nightSurchargePercentage: $nightSurchargePercentage, ')
          ..write('extraDaySurcharge: $extraDaySurcharge')
          ..write(')'))
        .toString();
  }
}

class $PaymentHistoryTable extends PaymentHistory
    with TableInfo<$PaymentHistoryTable, PaymentHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodStartMeta =
      const VerificationMeta('periodStart');
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
      'period_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _periodEndMeta =
      const VerificationMeta('periodEnd');
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
      'period_end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expectedAmountMeta =
      const VerificationMeta('expectedAmount');
  @override
  late final GeneratedColumn<int> expectedAmount = GeneratedColumn<int>(
      'expected_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _extraDeductionsMeta =
      const VerificationMeta('extraDeductions');
  @override
  late final GeneratedColumn<int> extraDeductions = GeneratedColumn<int>(
      'extra_deductions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        periodStart,
        periodEnd,
        expectedAmount,
        paidAmount,
        extraDeductions,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_history';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_start')) {
      context.handle(
          _periodStartMeta,
          periodStart.isAcceptableOrUnknown(
              data['period_start']!, _periodStartMeta));
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(_periodEndMeta,
          periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta));
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
          _expectedAmountMeta,
          expectedAmount.isAcceptableOrUnknown(
              data['expected_amount']!, _expectedAmountMeta));
    } else if (isInserting) {
      context.missing(_expectedAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('extra_deductions')) {
      context.handle(
          _extraDeductionsMeta,
          extraDeductions.isAcceptableOrUnknown(
              data['extra_deductions']!, _extraDeductionsMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_start'])!,
      periodEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}period_end'])!,
      expectedAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expected_amount'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_amount'])!,
      extraDeductions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}extra_deductions'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
    );
  }

  @override
  $PaymentHistoryTable createAlias(String alias) {
    return $PaymentHistoryTable(attachedDatabase, alias);
  }
}

class PaymentHistoryData extends DataClass
    implements Insertable<PaymentHistoryData> {
  final int id;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int expectedAmount;
  final int paidAmount;
  final int extraDeductions;
  final String note;
  const PaymentHistoryData(
      {required this.id,
      required this.periodStart,
      required this.periodEnd,
      required this.expectedAmount,
      required this.paidAmount,
      required this.extraDeductions,
      required this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['expected_amount'] = Variable<int>(expectedAmount);
    map['paid_amount'] = Variable<int>(paidAmount);
    map['extra_deductions'] = Variable<int>(extraDeductions);
    map['note'] = Variable<String>(note);
    return map;
  }

  PaymentHistoryCompanion toCompanion(bool nullToAbsent) {
    return PaymentHistoryCompanion(
      id: Value(id),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      expectedAmount: Value(expectedAmount),
      paidAmount: Value(paidAmount),
      extraDeductions: Value(extraDeductions),
      note: Value(note),
    );
  }

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentHistoryData(
      id: serializer.fromJson<int>(json['id']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      expectedAmount: serializer.fromJson<int>(json['expectedAmount']),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      extraDeductions: serializer.fromJson<int>(json['extraDeductions']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'expectedAmount': serializer.toJson<int>(expectedAmount),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'extraDeductions': serializer.toJson<int>(extraDeductions),
      'note': serializer.toJson<String>(note),
    };
  }

  PaymentHistoryData copyWith(
          {int? id,
          DateTime? periodStart,
          DateTime? periodEnd,
          int? expectedAmount,
          int? paidAmount,
          int? extraDeductions,
          String? note}) =>
      PaymentHistoryData(
        id: id ?? this.id,
        periodStart: periodStart ?? this.periodStart,
        periodEnd: periodEnd ?? this.periodEnd,
        expectedAmount: expectedAmount ?? this.expectedAmount,
        paidAmount: paidAmount ?? this.paidAmount,
        extraDeductions: extraDeductions ?? this.extraDeductions,
        note: note ?? this.note,
      );
  PaymentHistoryData copyWithCompanion(PaymentHistoryCompanion data) {
    return PaymentHistoryData(
      id: data.id.present ? data.id.value : this.id,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      extraDeductions: data.extraDeductions.present
          ? data.extraDeductions.value
          : this.extraDeductions,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentHistoryData(')
          ..write('id: $id, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('extraDeductions: $extraDeductions, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodStart, periodEnd, expectedAmount,
      paidAmount, extraDeductions, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentHistoryData &&
          other.id == this.id &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.expectedAmount == this.expectedAmount &&
          other.paidAmount == this.paidAmount &&
          other.extraDeductions == this.extraDeductions &&
          other.note == this.note);
}

class PaymentHistoryCompanion extends UpdateCompanion<PaymentHistoryData> {
  final Value<int> id;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<int> expectedAmount;
  final Value<int> paidAmount;
  final Value<int> extraDeductions;
  final Value<String> note;
  const PaymentHistoryCompanion({
    this.id = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.extraDeductions = const Value.absent(),
    this.note = const Value.absent(),
  });
  PaymentHistoryCompanion.insert({
    this.id = const Value.absent(),
    required DateTime periodStart,
    required DateTime periodEnd,
    required int expectedAmount,
    required int paidAmount,
    this.extraDeductions = const Value.absent(),
    this.note = const Value.absent(),
  })  : periodStart = Value(periodStart),
        periodEnd = Value(periodEnd),
        expectedAmount = Value(expectedAmount),
        paidAmount = Value(paidAmount);
  static Insertable<PaymentHistoryData> custom({
    Expression<int>? id,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<int>? expectedAmount,
    Expression<int>? paidAmount,
    Expression<int>? extraDeductions,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (extraDeductions != null) 'extra_deductions': extraDeductions,
      if (note != null) 'note': note,
    });
  }

  PaymentHistoryCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? periodStart,
      Value<DateTime>? periodEnd,
      Value<int>? expectedAmount,
      Value<int>? paidAmount,
      Value<int>? extraDeductions,
      Value<String>? note}) {
    return PaymentHistoryCompanion(
      id: id ?? this.id,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      extraDeductions: extraDeductions ?? this.extraDeductions,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<int>(expectedAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (extraDeductions.present) {
      map['extra_deductions'] = Variable<int>(extraDeductions.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentHistoryCompanion(')
          ..write('id: $id, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('extraDeductions: $extraDeductions, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $DayEntriesTable dayEntries = $DayEntriesTable(this);
  late final $PayrollConfigsTable payrollConfigs = $PayrollConfigsTable(this);
  late final $PaymentHistoryTable paymentHistory = $PaymentHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [shifts, dayEntries, payrollConfigs, paymentHistory];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('shifts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('day_entries', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  required String name,
  required String abbreviation,
  required String startTime,
  required String endTime,
  required String colorHex,
  Value<bool> isNightShift,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> abbreviation,
  Value<String> startTime,
  Value<String> endTime,
  Value<String> colorHex,
  Value<bool> isNightShift,
});

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DayEntriesTable, List<DayEntry>>
      _dayEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dayEntries,
              aliasName: 'shifts__id__day_entries__shift_id');

  $$DayEntriesTableProcessedTableManager get dayEntriesRefs {
    final manager = $$DayEntriesTableTableManager($_db, $_db.dayEntries)
        .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dayEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNightShift => $composableBuilder(
      column: $table.isNightShift, builder: (column) => ColumnFilters(column));

  Expression<bool> dayEntriesRefs(
      Expression<bool> Function($$DayEntriesTableFilterComposer f) f) {
    final $$DayEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dayEntries,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayEntriesTableFilterComposer(
              $db: $db,
              $table: $db.dayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNightShift => $composableBuilder(
      column: $table.isNightShift,
      builder: (column) => ColumnOrderings(column));
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isNightShift => $composableBuilder(
      column: $table.isNightShift, builder: (column) => column);

  Expression<T> dayEntriesRefs<T extends Object>(
      Expression<T> Function($$DayEntriesTableAnnotationComposer a) f) {
    final $$DayEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dayEntries,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.dayEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function({bool dayEntriesRefs})> {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> abbreviation = const Value.absent(),
            Value<String> startTime = const Value.absent(),
            Value<String> endTime = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isNightShift = const Value.absent(),
          }) =>
              ShiftsCompanion(
            id: id,
            name: name,
            abbreviation: abbreviation,
            startTime: startTime,
            endTime: endTime,
            colorHex: colorHex,
            isNightShift: isNightShift,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String abbreviation,
            required String startTime,
            required String endTime,
            required String colorHex,
            Value<bool> isNightShift = const Value.absent(),
          }) =>
              ShiftsCompanion.insert(
            id: id,
            name: name,
            abbreviation: abbreviation,
            startTime: startTime,
            endTime: endTime,
            colorHex: colorHex,
            isNightShift: isNightShift,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ShiftsTable, Shift>(table),
                    $$ShiftsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dayEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dayEntriesRefs) db.dayEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dayEntriesRefs)
                    await $_getPrefetchedDataByColumns<Shift, $ShiftsTable,
                            DayEntry, $DayEntriesTable>(
                        currentTable: table,
                        referencedTable:
                            $$ShiftsTableReferences._dayEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0)
                                .dayEntriesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'shift_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function({bool dayEntriesRefs})>;
typedef $$DayEntriesTableCreateCompanionBuilder = DayEntriesCompanion Function({
  Value<int> id,
  required DateTime date,
  Value<int?> shiftId,
  Value<String> note,
});
typedef $$DayEntriesTableUpdateCompanionBuilder = DayEntriesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int?> shiftId,
  Value<String> note,
});

final class $$DayEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DayEntriesTable, DayEntry> {
  $$DayEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) =>
      db.shifts.createAlias('day_entries__shift_id__shifts__id');

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<int>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DayEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DayEntriesTable> {
  $$DayEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DayEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayEntriesTable> {
  $$DayEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DayEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayEntriesTable> {
  $$DayEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DayEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DayEntriesTable,
    DayEntry,
    $$DayEntriesTableFilterComposer,
    $$DayEntriesTableOrderingComposer,
    $$DayEntriesTableAnnotationComposer,
    $$DayEntriesTableCreateCompanionBuilder,
    $$DayEntriesTableUpdateCompanionBuilder,
    (DayEntry, $$DayEntriesTableReferences),
    DayEntry,
    PrefetchHooks Function({bool shiftId})> {
  $$DayEntriesTableTableManager(_$AppDatabase db, $DayEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              DayEntriesCompanion(
            id: id,
            date: date,
            shiftId: shiftId,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<int?> shiftId = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              DayEntriesCompanion.insert(
            id: id,
            date: date,
            shiftId: shiftId,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DayEntriesTable, DayEntry>(table),
                    $$DayEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shiftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable:
                        $$DayEntriesTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$DayEntriesTableReferences._shiftIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DayEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DayEntriesTable,
    DayEntry,
    $$DayEntriesTableFilterComposer,
    $$DayEntriesTableOrderingComposer,
    $$DayEntriesTableAnnotationComposer,
    $$DayEntriesTableCreateCompanionBuilder,
    $$DayEntriesTableUpdateCompanionBuilder,
    (DayEntry, $$DayEntriesTableReferences),
    DayEntry,
    PrefetchHooks Function({bool shiftId})>;
typedef $$PayrollConfigsTableCreateCompanionBuilder = PayrollConfigsCompanion
    Function({
  Value<int> id,
  required int baseSalary,
  Value<bool> hasTransportAllowance,
  Value<int> transportAllowanceAmount,
  Value<String> frequency,
  Value<int> cutoffDay1,
  Value<int> cutoffDay2,
  Value<int> healthPercentage,
  Value<int> pensionPercentage,
  Value<int> nightSurchargePercentage,
  Value<int> extraDaySurcharge,
});
typedef $$PayrollConfigsTableUpdateCompanionBuilder = PayrollConfigsCompanion
    Function({
  Value<int> id,
  Value<int> baseSalary,
  Value<bool> hasTransportAllowance,
  Value<int> transportAllowanceAmount,
  Value<String> frequency,
  Value<int> cutoffDay1,
  Value<int> cutoffDay2,
  Value<int> healthPercentage,
  Value<int> pensionPercentage,
  Value<int> nightSurchargePercentage,
  Value<int> extraDaySurcharge,
});

class $$PayrollConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollConfigsTable> {
  $$PayrollConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transportAllowanceAmount => $composableBuilder(
      column: $table.transportAllowanceAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cutoffDay1 => $composableBuilder(
      column: $table.cutoffDay1, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cutoffDay2 => $composableBuilder(
      column: $table.cutoffDay2, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get healthPercentage => $composableBuilder(
      column: $table.healthPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pensionPercentage => $composableBuilder(
      column: $table.pensionPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nightSurchargePercentage => $composableBuilder(
      column: $table.nightSurchargePercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraDaySurcharge => $composableBuilder(
      column: $table.extraDaySurcharge,
      builder: (column) => ColumnFilters(column));
}

class $$PayrollConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollConfigsTable> {
  $$PayrollConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transportAllowanceAmount => $composableBuilder(
      column: $table.transportAllowanceAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cutoffDay1 => $composableBuilder(
      column: $table.cutoffDay1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cutoffDay2 => $composableBuilder(
      column: $table.cutoffDay2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get healthPercentage => $composableBuilder(
      column: $table.healthPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pensionPercentage => $composableBuilder(
      column: $table.pensionPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nightSurchargePercentage => $composableBuilder(
      column: $table.nightSurchargePercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraDaySurcharge => $composableBuilder(
      column: $table.extraDaySurcharge,
      builder: (column) => ColumnOrderings(column));
}

class $$PayrollConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollConfigsTable> {
  $$PayrollConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => column);

  GeneratedColumn<bool> get hasTransportAllowance => $composableBuilder(
      column: $table.hasTransportAllowance, builder: (column) => column);

  GeneratedColumn<int> get transportAllowanceAmount => $composableBuilder(
      column: $table.transportAllowanceAmount, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get cutoffDay1 => $composableBuilder(
      column: $table.cutoffDay1, builder: (column) => column);

  GeneratedColumn<int> get cutoffDay2 => $composableBuilder(
      column: $table.cutoffDay2, builder: (column) => column);

  GeneratedColumn<int> get healthPercentage => $composableBuilder(
      column: $table.healthPercentage, builder: (column) => column);

  GeneratedColumn<int> get pensionPercentage => $composableBuilder(
      column: $table.pensionPercentage, builder: (column) => column);

  GeneratedColumn<int> get nightSurchargePercentage => $composableBuilder(
      column: $table.nightSurchargePercentage, builder: (column) => column);

  GeneratedColumn<int> get extraDaySurcharge => $composableBuilder(
      column: $table.extraDaySurcharge, builder: (column) => column);
}

class $$PayrollConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollConfigsTable,
    PayrollConfig,
    $$PayrollConfigsTableFilterComposer,
    $$PayrollConfigsTableOrderingComposer,
    $$PayrollConfigsTableAnnotationComposer,
    $$PayrollConfigsTableCreateCompanionBuilder,
    $$PayrollConfigsTableUpdateCompanionBuilder,
    (
      PayrollConfig,
      BaseReferences<_$AppDatabase, $PayrollConfigsTable, PayrollConfig>
    ),
    PayrollConfig,
    PrefetchHooks Function()> {
  $$PayrollConfigsTableTableManager(
      _$AppDatabase db, $PayrollConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> baseSalary = const Value.absent(),
            Value<bool> hasTransportAllowance = const Value.absent(),
            Value<int> transportAllowanceAmount = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<int> cutoffDay1 = const Value.absent(),
            Value<int> cutoffDay2 = const Value.absent(),
            Value<int> healthPercentage = const Value.absent(),
            Value<int> pensionPercentage = const Value.absent(),
            Value<int> nightSurchargePercentage = const Value.absent(),
            Value<int> extraDaySurcharge = const Value.absent(),
          }) =>
              PayrollConfigsCompanion(
            id: id,
            baseSalary: baseSalary,
            hasTransportAllowance: hasTransportAllowance,
            transportAllowanceAmount: transportAllowanceAmount,
            frequency: frequency,
            cutoffDay1: cutoffDay1,
            cutoffDay2: cutoffDay2,
            healthPercentage: healthPercentage,
            pensionPercentage: pensionPercentage,
            nightSurchargePercentage: nightSurchargePercentage,
            extraDaySurcharge: extraDaySurcharge,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int baseSalary,
            Value<bool> hasTransportAllowance = const Value.absent(),
            Value<int> transportAllowanceAmount = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<int> cutoffDay1 = const Value.absent(),
            Value<int> cutoffDay2 = const Value.absent(),
            Value<int> healthPercentage = const Value.absent(),
            Value<int> pensionPercentage = const Value.absent(),
            Value<int> nightSurchargePercentage = const Value.absent(),
            Value<int> extraDaySurcharge = const Value.absent(),
          }) =>
              PayrollConfigsCompanion.insert(
            id: id,
            baseSalary: baseSalary,
            hasTransportAllowance: hasTransportAllowance,
            transportAllowanceAmount: transportAllowanceAmount,
            frequency: frequency,
            cutoffDay1: cutoffDay1,
            cutoffDay2: cutoffDay2,
            healthPercentage: healthPercentage,
            pensionPercentage: pensionPercentage,
            nightSurchargePercentage: nightSurchargePercentage,
            extraDaySurcharge: extraDaySurcharge,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollConfigsTable, PayrollConfig>(table),
                    BaseReferences<_$AppDatabase, $PayrollConfigsTable,
                        PayrollConfig>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PayrollConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollConfigsTable,
    PayrollConfig,
    $$PayrollConfigsTableFilterComposer,
    $$PayrollConfigsTableOrderingComposer,
    $$PayrollConfigsTableAnnotationComposer,
    $$PayrollConfigsTableCreateCompanionBuilder,
    $$PayrollConfigsTableUpdateCompanionBuilder,
    (
      PayrollConfig,
      BaseReferences<_$AppDatabase, $PayrollConfigsTable, PayrollConfig>
    ),
    PayrollConfig,
    PrefetchHooks Function()>;
typedef $$PaymentHistoryTableCreateCompanionBuilder = PaymentHistoryCompanion
    Function({
  Value<int> id,
  required DateTime periodStart,
  required DateTime periodEnd,
  required int expectedAmount,
  required int paidAmount,
  Value<int> extraDeductions,
  Value<String> note,
});
typedef $$PaymentHistoryTableUpdateCompanionBuilder = PaymentHistoryCompanion
    Function({
  Value<int> id,
  Value<DateTime> periodStart,
  Value<DateTime> periodEnd,
  Value<int> expectedAmount,
  Value<int> paidAmount,
  Value<int> extraDeductions,
  Value<String> note,
});

class $$PaymentHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentHistoryTable> {
  $$PaymentHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraDeductions => $composableBuilder(
      column: $table.extraDeductions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$PaymentHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentHistoryTable> {
  $$PaymentHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
      column: $table.periodEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraDeductions => $composableBuilder(
      column: $table.extraDeductions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$PaymentHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentHistoryTable> {
  $$PaymentHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
      column: $table.periodStart, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<int> get expectedAmount => $composableBuilder(
      column: $table.expectedAmount, builder: (column) => column);

  GeneratedColumn<int> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<int> get extraDeductions => $composableBuilder(
      column: $table.extraDeductions, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PaymentHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentHistoryTable,
    PaymentHistoryData,
    $$PaymentHistoryTableFilterComposer,
    $$PaymentHistoryTableOrderingComposer,
    $$PaymentHistoryTableAnnotationComposer,
    $$PaymentHistoryTableCreateCompanionBuilder,
    $$PaymentHistoryTableUpdateCompanionBuilder,
    (
      PaymentHistoryData,
      BaseReferences<_$AppDatabase, $PaymentHistoryTable, PaymentHistoryData>
    ),
    PaymentHistoryData,
    PrefetchHooks Function()> {
  $$PaymentHistoryTableTableManager(
      _$AppDatabase db, $PaymentHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> periodStart = const Value.absent(),
            Value<DateTime> periodEnd = const Value.absent(),
            Value<int> expectedAmount = const Value.absent(),
            Value<int> paidAmount = const Value.absent(),
            Value<int> extraDeductions = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              PaymentHistoryCompanion(
            id: id,
            periodStart: periodStart,
            periodEnd: periodEnd,
            expectedAmount: expectedAmount,
            paidAmount: paidAmount,
            extraDeductions: extraDeductions,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime periodStart,
            required DateTime periodEnd,
            required int expectedAmount,
            required int paidAmount,
            Value<int> extraDeductions = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              PaymentHistoryCompanion.insert(
            id: id,
            periodStart: periodStart,
            periodEnd: periodEnd,
            expectedAmount: expectedAmount,
            paidAmount: paidAmount,
            extraDeductions: extraDeductions,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PaymentHistoryTable, PaymentHistoryData>(
                        table),
                    BaseReferences<_$AppDatabase, $PaymentHistoryTable,
                        PaymentHistoryData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentHistoryTable,
    PaymentHistoryData,
    $$PaymentHistoryTableFilterComposer,
    $$PaymentHistoryTableOrderingComposer,
    $$PaymentHistoryTableAnnotationComposer,
    $$PaymentHistoryTableCreateCompanionBuilder,
    $$PaymentHistoryTableUpdateCompanionBuilder,
    (
      PaymentHistoryData,
      BaseReferences<_$AppDatabase, $PaymentHistoryTable, PaymentHistoryData>
    ),
    PaymentHistoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$DayEntriesTableTableManager get dayEntries =>
      $$DayEntriesTableTableManager(_db, _db.dayEntries);
  $$PayrollConfigsTableTableManager get payrollConfigs =>
      $$PayrollConfigsTableTableManager(_db, _db.payrollConfigs);
  $$PaymentHistoryTableTableManager get paymentHistory =>
      $$PaymentHistoryTableTableManager(_db, _db.paymentHistory);
}
