import '../data/database.dart';

class PayrollSummary {
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime countedUntil;
  final int daysWorked;
  final int restDays;
  final int totalMinutes;
  final int nightMinutes;
  final int extraDayMinutes;
  final int basePay;
  final int nightSurcharge;
  final int extraDaySurcharge;
  final int transportAllowance;
  final int gross;
  final int healthDeduction;
  final int pensionDeduction;
  final int extraDeductions;
  final int totalDeductions;
  final int net;
  final int hourlyRate;

  const PayrollSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.countedUntil,
    required this.daysWorked,
    required this.restDays,
    required this.totalMinutes,
    required this.nightMinutes,
    required this.extraDayMinutes,
    required this.basePay,
    required this.nightSurcharge,
    required this.extraDaySurcharge,
    required this.transportAllowance,
    required this.gross,
    required this.healthDeduction,
    required this.pensionDeduction,
    required this.extraDeductions,
    required this.totalDeductions,
    required this.net,
    required this.hourlyRate,
  });

  int get daysUntilPayment {
    final remaining = periodEnd.difference(countedUntil).inDays;
    return remaining < 0 ? 0 : remaining;
  }
}

int shiftDurationMinutes(String start, String end) {
  final startParts = _parseTime(start);
  final endParts = _parseTime(end);
  var minutes =
      (endParts[0] * 60 + endParts[1]) - (startParts[0] * 60 + startParts[1]);
  if (minutes <= 0) minutes += 24 * 60;
  return minutes;
}

List<int> _parseTime(String value) {
  final parts = value.split(':');
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return [hour, minute];
}

int _roundDiv(int numerator, int denominator) =>
    (numerator + denominator ~/ 2) ~/ denominator;

int _percentOf(int amount, int percentage) =>
    (amount * percentage + 50) ~/ 100;

int _standardHours(String frequency) =>
    frequency == 'BIWEEKLY' ? 80 : 160;

int _clampDay(int day, int year, int month) {
  final maxDay = DateTime(year, month + 1, 0).day;
  return day > maxDay ? maxDay : day;
}

DateTime _addMonths(DateTime date, int months) {
  final monthIndex = date.month - 1 + months;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final maxDay = DateTime(year, month + 1, 0).day;
  final day = date.day > maxDay ? maxDay : date.day;
  return DateTime(year, month, day);
}

(DateTime, DateTime) currentPeriod(PayrollConfig config, DateTime now) {
  if (config.frequency == 'BIWEEKLY') {
    return _biweeklyPeriod(config, now);
  }
  return _monthlyPeriod(config, now);
}

(DateTime, DateTime) _monthlyPeriod(PayrollConfig config, DateTime now) {
  final cutoff = _clampDay(config.cutoffDay1, now.year, now.month);
  if (now.day >= cutoff) {
    final start = DateTime(now.year, now.month, cutoff);
    return (start, _addMonths(start, 1));
  }
  final start = _addMonths(DateTime(now.year, now.month, cutoff), -1);
  return (start, DateTime(now.year, now.month, cutoff));
}

(DateTime, DateTime) _biweeklyPeriod(PayrollConfig config, DateTime now) {
  final first = config.cutoffDay1;
  final second = config.cutoffDay2;
  if (now.day >= second) {
    final start = DateTime(now.year, now.month, second);
    return (start, _addMonths(DateTime(now.year, now.month, first), 1));
  }
  if (now.day >= first) {
    return (
      DateTime(now.year, now.month, first),
      DateTime(now.year, now.month, second),
    );
  }
  final start = DateTime(now.year, now.month - 1, second);
  return (start, DateTime(now.year, now.month, first));
}

List<DateTime> nextPaymentDates(PayrollConfig config, DateTime now) {
  final (periodStart, periodEnd) = currentPeriod(config, now);
  final paymentDays = config.frequency == 'BIWEEKLY'
      ? [config.paymentDay2, config.paymentDay1]
      : [config.paymentDay1];

  final dates = <DateTime>[];
  for (final day in paymentDays) {
    var candidate = DateTime(periodEnd.year, periodEnd.month,
        _clampDay(day, periodEnd.year, periodEnd.month));
    if (candidate.isBefore(now) || candidate.isBefore(periodStart)) {
      candidate = _addMonths(candidate, 1);
    }
    dates.add(candidate);
  }
  dates.sort();
  return dates;
}

bool isHoliday(DateTime date) {
  final month = date.month;
  final day = date.day;
  const fixed = {
    (1, 1),
    (5, 1),
    (7, 20),
    (8, 7),
    (12, 8),
    (12, 25),
  };
  return fixed.contains((month, day));
}

PayrollSummary computePayroll({
  required List<Shift> shifts,
  required List<DayEntry> entries,
  required PayrollConfig config,
  required DateTime periodStart,
  required DateTime periodEnd,
  required DateTime now,
  required int extraDeductions,
}) {
  final shiftsById = {for (final shift in shifts) shift.id: shift};
  final entriesByDay = {
    for (final entry in entries)
      DateTime(entry.date.year, entry.date.month, entry.date.day): entry,
  };
  final countedUntil = DateTime(now.year, now.month, now.day);

  var daysWorked = 0;
  var restDays = 0;
  var totalMinutes = 0;
  var nightMinutes = 0;
  var extraDayMinutes = 0;

  var day = DateTime(periodStart.year, periodStart.month, periodStart.day);
  while (!day.isAfter(countedUntil)) {
    final entry = entriesByDay[day];
    final shift = entry == null ? null : shiftsById[entry.shiftId];

    if (shift == null || shift.isRestDay) {
      restDays++;
    } else {
      daysWorked++;
      final minutes = shiftDurationMinutes(shift.startTime, shift.endTime);
      totalMinutes += minutes;
      if (shift.isNightShift) nightMinutes += minutes;
      if (shift.appliesSundaySurcharge && day.weekday == DateTime.sunday) {
        extraDayMinutes += minutes;
      }
      if (shift.appliesHolidaySurcharge && isHoliday(day)) {
        extraDayMinutes += minutes;
      }
    }
    day = day.add(const Duration(days: 1));
  }

  final standardHours = _standardHours(config.frequency);
  final hourlyRate = config.baseSalary ~/ standardHours;

  final basePay = _roundDiv(totalMinutes * hourlyRate, 60);
  final nightPay = _roundDiv(nightMinutes * hourlyRate, 60);
  final extraDayPay = _roundDiv(extraDayMinutes * hourlyRate, 60);

  final nightSurcharge = _percentOf(nightPay, config.nightSurchargePercentage);
  final extraDaySurcharge =
      _percentOf(extraDayPay, config.extraDaySurcharge);
  final transportAllowance = config.hasTransportAllowance && daysWorked > 0
      ? config.transportAllowanceAmount
      : 0;

  final gross = basePay +
      nightSurcharge +
      extraDaySurcharge +
      transportAllowance;
  final healthDeduction = _percentOf(basePay, config.healthPercentage);
  final pensionDeduction = _percentOf(basePay, config.pensionPercentage);
  final totalDeductions =
      healthDeduction + pensionDeduction + extraDeductions;
  final net = gross - totalDeductions;

  return PayrollSummary(
    periodStart: periodStart,
    periodEnd: periodEnd,
    countedUntil: countedUntil,
    daysWorked: daysWorked,
    restDays: restDays,
    totalMinutes: totalMinutes,
    nightMinutes: nightMinutes,
    extraDayMinutes: extraDayMinutes,
    basePay: basePay,
    nightSurcharge: nightSurcharge,
    extraDaySurcharge: extraDaySurcharge,
    transportAllowance: transportAllowance,
    gross: gross,
    healthDeduction: healthDeduction,
    pensionDeduction: pensionDeduction,
    extraDeductions: extraDeductions,
    totalDeductions: totalDeductions,
    net: net,
    hourlyRate: hourlyRate,
  );
}

int computeMonthGross({
  required List<Shift> shifts,
  required List<DayEntry> entries,
  required PayrollConfig config,
  required int year,
  required int month,
}) {
  final shiftsById = {for (final shift in shifts) shift.id: shift};
  final monthStart = DateTime(year, month, 1);
  final monthEnd = DateTime(year, month + 1, 1);
  final standardHours = _standardHours(config.frequency);
  final hourlyRate = config.baseSalary ~/ standardHours;

  var minutes = 0;
  var nightMinutes = 0;
  var extraMinutes = 0;

  for (final entry in entries) {
    final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
    if (date.isBefore(monthStart) || !date.isBefore(monthEnd)) continue;
    final shift = entry.shiftId == null ? null : shiftsById[entry.shiftId];
    if (shift == null || shift.isRestDay) continue;
    final duration = shiftDurationMinutes(shift.startTime, shift.endTime);
    minutes += duration;
    if (shift.isNightShift) nightMinutes += duration;
    if (shift.appliesSundaySurcharge && entry.date.weekday == DateTime.sunday) {
      extraMinutes += duration;
    }
    if (shift.appliesHolidaySurcharge && isHoliday(date)) {
      extraMinutes += duration;
    }
  }

  final basePay = _roundDiv(minutes * hourlyRate, 60);
  final nightPay = _roundDiv(nightMinutes * hourlyRate, 60);
  final extraPay = _roundDiv(extraMinutes * hourlyRate, 60);
  return basePay +
      _percentOf(nightPay, config.nightSurchargePercentage) +
      _percentOf(extraPay, config.extraDaySurcharge);
}
