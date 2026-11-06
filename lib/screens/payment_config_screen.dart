import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/settings_common.dart';

class PaymentConfigScreen extends ConsumerWidget {
  const PaymentConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).valueOrNull;

    return SettingsScaffold(
      title: 'Fechas de pago',
      child: config == null
          ? const Center(child: CircularProgressIndicator())
          : _PaymentForm(config: config),
    );
  }
}

class _PaymentForm extends ConsumerStatefulWidget {
  final PayrollConfig config;

  const _PaymentForm({required this.config});

  @override
  ConsumerState<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<_PaymentForm> {
  late final TextEditingController _cutoff1Controller;
  late final TextEditingController _cutoff2Controller;
  late final TextEditingController _payment1Controller;
  late final TextEditingController _payment2Controller;
  late String _frequency;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    _cutoff1Controller =
        TextEditingController(text: config.cutoffDay1.toString());
    _cutoff2Controller =
        TextEditingController(text: config.cutoffDay2.toString());
    _payment1Controller =
        TextEditingController(text: config.paymentDay1.toString());
    _payment2Controller =
        TextEditingController(text: config.paymentDay2.toString());
    _frequency = config.frequency;
  }

  @override
  void dispose() {
    _cutoff1Controller.dispose();
    _cutoff2Controller.dispose();
    _payment1Controller.dispose();
    _payment2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isBiweekly = _frequency == 'BIWEEKLY';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: [
        SectionCard(
          title: 'Frecuencia',
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'MONTHLY',
                    label: FittedBox(fit: BoxFit.scaleDown, child: Text('Mensual')),
                  ),
                  ButtonSegment(
                    value: 'BIWEEKLY',
                    label:
                        FittedBox(fit: BoxFit.scaleDown, child: Text('Quincenal')),
                  ),
                ],
                selected: {_frequency},
                onSelectionChanged: (selection) =>
                    setState(() => _frequency = selection.first),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Días de corte',
          children: [
            Row(
              children: [
                Expanded(
                  child: _field(_cutoff1Controller, 'Corte 1 (día)'),
                ),
                if (isBiweekly) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(_cutoff2Controller, 'Corte 2 (día)'),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Días de pago',
          children: [
            Row(
              children: [
                Expanded(
                  child: _field(_payment1Controller, 'Pago 1 (día)'),
                ),
                if (isBiweekly) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field(_payment2Controller, 'Pago 2 (día)'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isBiweekly
                  ? 'El pago quincenal se divide en dos fechas.'
                  : 'Pago mensual en una sola fecha.',
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GlassActionButton(
          label: 'Guardar fechas',
          icon: Icons.save_rounded,
          onTap: _save,
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await (db.update(db.payrollConfigs)
          ..where((t) => t.id.equals(widget.config.id)))
        .write(
      PayrollConfigsCompanion(
        frequency: Value(_frequency),
        cutoffDay1: Value(
            int.tryParse(_cutoff1Controller.text) ?? widget.config.cutoffDay1),
        cutoffDay2: Value(
            int.tryParse(_cutoff2Controller.text) ?? widget.config.cutoffDay2),
        paymentDay1: Value(int.tryParse(_payment1Controller.text) ??
            widget.config.paymentDay1),
        paymentDay2: Value(int.tryParse(_payment2Controller.text) ??
            widget.config.paymentDay2),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fechas guardadas correctamente.')),
    );
  }
}
