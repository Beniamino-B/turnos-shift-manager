import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import 'glass.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(payrollSummaryProvider);
    if (summary == null) {
      return const SizedBox.shrink();
    }

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      borderRadius: 22,
      child: Row(
        children: [
          _SummaryStat(
            label: 'Trabajados',
            value: '${summary.daysWorked}',
            color: AppColors.primary,
          ),
          _divider(),
          _SummaryStat(
            label: 'Descanso',
            value: '${summary.restDays}',
            color: AppColors.accent,
          ),
          _divider(),
          _SummaryStat(
            label: 'Faltan para pago',
            value: '${summary.daysUntilPayment} días',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withValues(alpha: 0.7),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
