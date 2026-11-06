import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/settings_common.dart';

class PayrollConfigScreen extends ConsumerWidget {
  const PayrollConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).valueOrNull;

    return SettingsScaffold(
      title: 'Nómina',
      child: config == null
          ? const Center(child: CircularProgressIndicator())
          : _PayrollForm(config: config),
    );
  }
}

class _PayrollForm extends ConsumerStatefulWidget {
  final PayrollConfig config;

  const _PayrollForm({required this.config});

  @override
  ConsumerState<_PayrollForm> createState() => _PayrollFormState();
}

class _PayrollFormState extends ConsumerState<_PayrollForm> {
  late final TextEditingController _baseController;
  late final TextEditingController _transportController;
  late final TextEditingController _healthController;
  late final TextEditingController _pensionController;
  late final TextEditingController _nightController;
  late final TextEditingController _extraController;
  late bool _transport;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    _baseController =
        TextEditingController(text: (config.baseSalary ~/ 100).toString());
    _transportController = TextEditingController(
        text: (config.transportAllowanceAmount ~/ 100).toString());
    _healthController =
        TextEditingController(text: config.healthPercentage.toString());
    _pensionController =
        TextEditingController(text: config.pensionPercentage.toString());
    _nightController = TextEditingController(
        text: config.nightSurchargePercentage.toString());
    _extraController =
        TextEditingController(text: config.extraDaySurcharge.toString());
    _transport = config.hasTransportAllowance;
  }

  @override
  void dispose() {
    _baseController.dispose();
    _transportController.dispose();
    _healthController.dispose();
    _pensionController.dispose();
    _nightController.dispose();
    _extraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      children: [
        SectionCard(
          title: 'Salario y transporte',
          children: [
            _field(_baseController, 'Salario base (COP)',
                TextInputType.number, Icons.payments_rounded),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _transport,
              onChanged: (value) => setState(() => _transport = value),
              activeTrackColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Subsidio de transporte',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              subtitle: Text(
                'Activa el auxilio de transporte mensual',
                style:
                    TextStyle(fontSize: 11, color: palette.textSecondary),
              ),
            ),
            if (_transport) ...[
              const SizedBox(height: 8),
              _field(_transportController, 'Monto de transporte (COP)',
                  TextInputType.number, Icons.directions_bus_rounded),
            ],
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Deducciones',
          children: [
            Row(
              children: [
                Expanded(
                  child: _field(_healthController, 'Salud %',
                      TextInputType.number, Icons.favorite_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(_pensionController, 'Pensión %',
                      TextInputType.number, Icons.savings_rounded),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Recargos',
          children: [
            Row(
              children: [
                Expanded(
                  child: _field(_nightController, 'Nocturno %',
                      TextInputType.number, Icons.nights_stay_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(_extraController, 'Dominical %',
                      TextInputType.number, Icons.calendar_today_rounded),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        GlassActionButton(
          label: 'Guardar configuración',
          icon: Icons.save_rounded,
          onTap: _save,
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }

  Future<void> _save() async {
    final base = parsePesosToCents(_baseController.text);
    if (base == null) {
      _showSnack('Ingresa un salario base válido.');
      return;
    }
    final transport = parsePesosToCents(_transportController.text) ?? 0;
    final db = ref.read(databaseProvider);
    await (db.update(db.payrollConfigs)
          ..where((t) => t.id.equals(widget.config.id)))
        .write(
      PayrollConfigsCompanion(
        baseSalary: Value(base),
        hasTransportAllowance: Value(_transport),
        transportAllowanceAmount: Value(transport),
        healthPercentage: Value(
            int.tryParse(_healthController.text) ?? widget.config.healthPercentage),
        pensionPercentage: Value(int.tryParse(_pensionController.text) ??
            widget.config.pensionPercentage),
        nightSurchargePercentage: Value(int.tryParse(_nightController.text) ??
            widget.config.nightSurchargePercentage),
        extraDaySurcharge: Value(int.tryParse(_extraController.text) ??
            widget.config.extraDaySurcharge),
      ),
    );
    _showSnack('Configuración guardada correctamente.');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
