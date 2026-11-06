import 'package:flutter/material.dart';

const List<String> spanishMonths = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

const List<String> spanishWeekdayInitials = [
  'L',
  'M',
  'X',
  'J',
  'V',
  'S',
  'D',
];

const List<String> spanishWeekdayNames = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

String formatMoney(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final pesos = absolute ~/ 100;
  final fraction = absolute % 100;
  final digits = pesos.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  var result = '\$$sign${buffer.toString()}';
  if (fraction != 0) {
    result += ',${fraction.toString().padLeft(2, '0')}';
  }
  return result;
}

String formatMoneyCompact(int cents) {
  final pesos = cents ~/ 100;
  if (pesos >= 1000000) {
    final millions = pesos ~/ 1000000;
    final tenths = (pesos % 1000000) ~/ 100000;
    return tenths == 0 ? '\$$millions M' : '\$$millions,$tenths M';
  }
  if (pesos >= 1000) {
    return '\$${pesos ~/ 1000} K';
  }
  return '\$$pesos';
}

int? parsePesosToCents(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return int.parse(digits) * 100;
}

String formatMonthYear(DateTime date) =>
    '${spanishMonths[date.month - 1]} ${date.year}';

String formatDateShort(DateTime date) =>
    '${date.day} ${spanishMonths[date.month - 1].substring(0, 3)} ${date.year}';

String formatMinutes(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  if (hours == 0) return '${mins}m';
  if (mins == 0) return '${hours}h';
  return '${hours}h ${mins}m';
}

Color colorFromHex(String hex, {Color fallback = AppColorsFallback.primary}) {
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  final parsed = int.tryParse(value, radix: 16);
  if (parsed == null) return fallback;
  return Color(parsed);
}

String colorToHex(Color color) {
  final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
  final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
  final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#$r$g$b';
}

class AppColorsFallback {
  static const Color primary = Color(0xFF5B5FEF);
}
