import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../domain/payroll_engine.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _titleBar(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassContainer(
              padding: const EdgeInsets.all(5),
              borderRadius: 20,
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppPalette.of(context).textSecondary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Resumen'),
                  Tab(text: 'Historial'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: TabBarView(
              children: [
                _ResumenTab(),
                _HistorialTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBar(BuildContext context) {
    final palette = AppPalette.of(context);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 26,
      child: Row(
        children: [
          const Icon(Icons.pie_chart_rounded,
              color: AppColors.primary, size: 26),
          const SizedBox(width: 10),
          Text(
            'Finanzas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenTab extends ConsumerWidget {
  const _ResumenTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final summary = ref.watch(payrollSummaryProvider);
    final config = ref.watch(configProvider).valueOrNull;
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const <Shift>[];
    final entries =
        ref.watch(entriesProvider).valueOrNull ?? const <DayEntry>[];

    if (summary == null || config == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
      children: [
        _topSummaryCard(summary, palette),
        const SizedBox(height: 14),
        _earningsChartCard(config, shifts, entries, palette),
        const SizedBox(height: 14),
        _breakdownCard(summary, config, palette),
        const SizedBox(height: 14),
        GlassActionButton(
          label: 'Registrar pago',
          icon: Icons.payments_rounded,
          onTap: () => _showRegisterPayment(context),
        ),
      ],
    );
  }

  Widget _topSummaryCard(PayrollSummary summary, AppPalette palette) {
    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu nómina actual',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatMoney(summary.net),
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Neto a recibir',
            style: TextStyle(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _miniStat(
                'Bruto',
                formatMoney(summary.gross),
                AppColors.primary,
                palette,
              ),
              const SizedBox(width: 20),
              _miniStat(
                'Deducciones',
                formatMoney(summary.totalDeductions),
                AppColors.danger,
                palette,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
      String label, String value, Color color, AppPalette palette) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _earningsChartCard(
    PayrollConfig config,
    List<Shift> shifts,
    List<DayEntry> entries,
    AppPalette palette,
  ) {
    final data = _lastThreeMonths(config, shifts, entries);
    final maxValue = data.map((e) => e.$2).fold(0, max);
    final maxY = maxValue == 0 ? 100000.0 : maxValue * 1.25;

    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tendencia de ingresos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Últimos 3 meses',
            style: TextStyle(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          formatMoneyCompact(value.toInt()),
                          style: TextStyle(
                            fontSize: 9,
                            color: palette.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            data[index].$1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < data.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i].$2.toDouble(),
                          color: AppColors.primary,
                          width: 22,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownCard(
      PayrollSummary summary, PayrollConfig config, AppPalette palette) {
    final rows = <(String, int, Color)>[
      ('Horas base (${formatMinutes(summary.totalMinutes)})',
          summary.basePay, AppColors.primary),
      ('Recargo nocturno', summary.nightSurcharge, AppColors.night),
      ('Recargo dominical', summary.extraDaySurcharge, AppColors.night),
      ('Subsidio de transporte',
          summary.transportAllowance, AppColors.accent),
      ('Salud (${config.healthPercentage}%)', -summary.healthDeduction,
          AppColors.danger),
      ('Pensión (${config.pensionPercentage}%)', -summary.pensionDeduction,
          AppColors.danger),
      ('Deducciones adicionales', -summary.extraDeductions, AppColors.danger),
    ];

    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desglose de nómina',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${row.$3 == AppColors.danger ? '-' : '+'}${formatMoney(row.$2.abs())}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: row.$3,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistorialTab extends ConsumerWidget {
  const _HistorialTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final payments = ref.watch(paymentHistoryProvider).valueOrNull ??
        const <PaymentHistoryData>[];

    if (payments.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 130),
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.history_rounded,
                    color: palette.textSecondary, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Aún no hay pagos registrados',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Registra tu primer pago en la pestaña Resumen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 10),
          borderRadius: 22,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${formatDateShort(payment.periodStart)} - ${formatDateShort(payment.periodEnd)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    formatMoney(payment.paidAmount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _historyStat(
                      'Esperado', formatMoney(payment.expectedAmount), palette),
                  const SizedBox(width: 16),
                  _historyStat('Deducciones',
                      formatMoney(payment.extraDeductions), palette),
                ],
              ),
              if (payment.note.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  payment.note,
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _historyStat(String label, String value, AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}

void _showRegisterPayment(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _RegisterPaymentSheet(),
  );
}

class _RegisterPaymentSheet extends ConsumerStatefulWidget {
  const _RegisterPaymentSheet();

  @override
  ConsumerState<_RegisterPaymentSheet> createState() =>
      _RegisterPaymentSheetState();
}

class _RegisterPaymentSheetState
    extends ConsumerState<_RegisterPaymentSheet> {
  final _paidController = TextEditingController();
  final _deductionsController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _paidController.dispose();
    _deductionsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final summary = ref.watch(payrollSummaryProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        color: Colors.white.withValues(alpha: 0.95),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: palette.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Registrar pago',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              summary == null
                  ? 'Esperando datos...'
                  : 'Periodo: ${formatDateShort(summary.periodStart)} - ${formatDateShort(summary.periodEnd)}',
              style: TextStyle(
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _paidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto pagado (COP)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deductionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Deducciones adicionales (COP)',
                prefixIcon: Icon(Icons.remove_circle_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Nota (opcional)',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),
            const SizedBox(height: 20),
            GlassActionButton(
              label: 'Guardar pago',
              icon: Icons.check_rounded,
              onTap: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final summary = ref.read(payrollSummaryProvider);
    final paid = parsePesosToCents(_paidController.text);
    if (summary == null || paid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido.')),
      );
      return;
    }
    final deductions = parsePesosToCents(_deductionsController.text) ?? 0;
    final db = ref.read(databaseProvider);
    await db.into(db.paymentHistory).insert(
          PaymentHistoryCompanion.insert(
            periodStart: summary.periodStart,
            periodEnd: summary.periodEnd,
            expectedAmount: summary.net,
            paidAmount: paid,
            extraDeductions: Value(deductions),
            note: Value(_noteController.text.trim()),
          ),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pago registrado correctamente.')),
    );
  }
}

List<(String, int)> _lastThreeMonths(
  PayrollConfig config,
  List<Shift> shifts,
  List<DayEntry> entries,
) {
  final now = DateTime.now();
  final result = <(String, int)>[];
  for (var i = 2; i >= 0; i--) {
    final monthIndex = now.month - 1 - i;
    final year = now.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final gross = computeMonthGross(
      shifts: shifts,
      entries: entries,
      config: config,
      year: year,
      month: month,
    );
    result.add((spanishMonths[month - 1].substring(0, 3), gross));
  }
  return result;
}
