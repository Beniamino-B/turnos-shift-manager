import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';

const List<String> _shiftPalette = [
  '#5B5FEF',
  '#FF9F43',
  '#7C3AED',
  '#22C55E',
  '#EF4444',
  '#0EA5E9',
  '#EC4899',
  '#F59E0B',
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).valueOrNull;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
      children: [
        const SizedBox(height: 8),
        const _TitleBar(),
        const SizedBox(height: 14),
        if (config == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          )
        else
          _PayrollConfigForm(config: config),
        const SizedBox(height: 14),
        const _ShiftSection(),
        const SizedBox(height: 14),
        const _NotificationSection(),
      ],
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    return const GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 26,
      child: Row(
        children: [
          Icon(Icons.settings_rounded, color: AppColors.primary, size: 26),
          SizedBox(width: 10),
          Text(
            'Ajustes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayrollConfigForm extends ConsumerStatefulWidget {
  final PayrollConfig config;

  const _PayrollConfigForm({required this.config});

  @override
  ConsumerState<_PayrollConfigForm> createState() => _PayrollConfigFormState();
}

class _PayrollConfigFormState extends ConsumerState<_PayrollConfigForm> {
  late final TextEditingController _baseController;
  late final TextEditingController _transportController;
  late final TextEditingController _cutoff1Controller;
  late final TextEditingController _cutoff2Controller;
  late final TextEditingController _healthController;
  late final TextEditingController _pensionController;
  late final TextEditingController _nightController;
  late final TextEditingController _extraController;
  late bool _transport;
  late String _frequency;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    _baseController =
        TextEditingController(text: (config.baseSalary ~/ 100).toString());
    _transportController =
        TextEditingController(text: (config.transportAllowanceAmount ~/ 100).toString());
    _cutoff1Controller =
        TextEditingController(text: config.cutoffDay1.toString());
    _cutoff2Controller =
        TextEditingController(text: config.cutoffDay2.toString());
    _healthController =
        TextEditingController(text: config.healthPercentage.toString());
    _pensionController =
        TextEditingController(text: config.pensionPercentage.toString());
    _nightController =
        TextEditingController(text: config.nightSurchargePercentage.toString());
    _extraController =
        TextEditingController(text: config.extraDaySurcharge.toString());
    _transport = config.hasTransportAllowance;
    _frequency = config.frequency;
  }

  @override
  void dispose() {
    _baseController.dispose();
    _transportController.dispose();
    _cutoff1Controller.dispose();
    _cutoff2Controller.dispose();
    _healthController.dispose();
    _pensionController.dispose();
    _nightController.dispose();
    _extraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Configuración de nómina',
            icon: Icons.account_balance_wallet_rounded,
          ),
          _field(_baseController, 'Salario base (COP)', TextInputType.number,
              Icons.payments_rounded),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'MONTHLY',
                label: Text('Mensual'),
                icon: Icon(Icons.calendar_view_month_rounded),
              ),
              ButtonSegment(
                value: 'BIWEEKLY',
                label: Text('Quincenal'),
                icon: Icon(Icons.view_week_rounded),
              ),
            ],
            selected: {_frequency},
            onSelectionChanged: (selection) =>
                setState(() => _frequency = selection.first),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _field(
                  _cutoff1Controller,
                  'Corte 1 (día)',
                  TextInputType.number,
                  Icons.event_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  _cutoff2Controller,
                  'Corte 2 (día)',
                  TextInputType.number,
                  Icons.event_available_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _transport,
            onChanged: (value) => setState(() => _transport = value),
            activeTrackColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Subsidio de transporte',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Activa el auxilio de transporte mensual',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          if (_transport) ...[
            const SizedBox(height: 8),
            _field(
              _transportController,
              'Monto de transporte (COP)',
              TextInputType.number,
              Icons.directions_bus_rounded,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _field(
                  _healthController,
                  'Salud %',
                  TextInputType.number,
                  Icons.favorite_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  _pensionController,
                  'Pensión %',
                  TextInputType.number,
                  Icons.savings_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _field(
                  _nightController,
                  'Recargo nocturno %',
                  TextInputType.number,
                  Icons.nights_stay_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  _extraController,
                  'Recargo dominical %',
                  TextInputType.number,
                  Icons.calendar_today_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GlassActionButton(
            label: 'Guardar configuración',
            icon: Icons.save_rounded,
            onTap: _save,
          ),
        ],
      ),
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
        frequency: Value(_frequency),
        cutoffDay1: Value(int.tryParse(_cutoff1Controller.text) ?? widget.config.cutoffDay1),
        cutoffDay2: Value(int.tryParse(_cutoff2Controller.text) ?? widget.config.cutoffDay2),
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

class _ShiftSection extends ConsumerWidget {
  const _ShiftSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const <Shift>[];

    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Tipos de turno',
            icon: Icons.work_outline_rounded,
          ),
          for (final shift in shifts) _shiftTile(context, ref, shift),
          const SizedBox(height: 8),
          GlassActionButton(
            label: 'Nuevo turno',
            icon: Icons.add_rounded,
            onTap: () => _showShiftEditor(context, null),
          ),
        ],
      ),
    );
  }

  Widget _shiftTile(BuildContext context, WidgetRef ref, Shift shift) {
    final color = colorFromHex(shift.colorHex);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${shift.startTime} - ${shift.endTime}  •  ${shift.abbreviation}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (shift.isNightShift)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.night.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Nocturno',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.night,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.edit_rounded,
                color: AppColors.textSecondary, size: 20),
            onPressed: () => _showShiftEditor(context, shift),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.danger, size: 20),
            onPressed: () => _deleteShift(ref, shift),
          ),
        ],
      ),
    );
  }

  void _showShiftEditor(BuildContext context, Shift? shift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShiftEditorSheet(shift: shift),
    );
  }

  Future<void> _deleteShift(WidgetRef ref, Shift shift) async {
    final db = ref.read(databaseProvider);
    await db.delete(db.shifts).delete(shift);
  }
}

class _ShiftEditorSheet extends ConsumerStatefulWidget {
  final Shift? shift;

  const _ShiftEditorSheet({this.shift});

  @override
  ConsumerState<_ShiftEditorSheet> createState() => _ShiftEditorSheetState();
}

class _ShiftEditorSheetState extends ConsumerState<_ShiftEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _abbrController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late bool _night;
  late String _colorHex;

  @override
  void initState() {
    super.initState();
    final shift = widget.shift;
    _nameController = TextEditingController(text: shift?.name ?? '');
    _abbrController = TextEditingController(text: shift?.abbreviation ?? '');
    _startController = TextEditingController(text: shift?.startTime ?? '06:00');
    _endController = TextEditingController(text: shift?.endTime ?? '14:00');
    _night = shift?.isNightShift ?? false;
    _colorHex = shift?.colorHex ?? _shiftPalette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbrController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        color: Colors.white.withValues(alpha: 0.96),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.shift == null ? 'Nuevo turno' : 'Editar turno',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _abbrController,
                      decoration:
                          const InputDecoration(labelText: 'Abrev.'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        labelText: 'Inicio (HH:mm)',
                        hintText: '06:00',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        labelText: 'Fin (HH:mm)',
                        hintText: '14:00',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _night,
                onChanged: (value) => setState(() => _night = value),
                activeTrackColor: AppColors.night,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Turno nocturno',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Color',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  for (final hex in _shiftPalette)
                    GestureDetector(
                      onTap: () => setState(() => _colorHex = hex),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colorFromHex(hex),
                          shape: BoxShape.circle,
                          border: _colorHex == hex
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: _colorHex == hex
                              ? [
                                  BoxShadow(
                                    color:
                                        colorFromHex(hex).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              GlassActionButton(
                label: widget.shift == null ? 'Crear turno' : 'Guardar cambios',
                icon: Icons.check_rounded,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final abbr = _abbrController.text.trim();
    if (name.isEmpty || abbr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre y abreviatura.')),
      );
      return;
    }
    final db = ref.read(databaseProvider);
    final companion = ShiftsCompanion(
      name: Value(name),
      abbreviation: Value(abbr),
      startTime: Value(_startController.text.trim()),
      endTime: Value(_endController.text.trim()),
      colorHex: Value(_colorHex),
      isNightShift: Value(_night),
    );
    if (widget.shift == null) {
      await db.into(db.shifts).insert(companion);
    } else {
      await (db.update(db.shifts)
            ..where((t) => t.id.equals(widget.shift!.id)))
          .write(companion);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Turno guardado correctamente.')),
    );
  }
}

class _NotificationSection extends StatefulWidget {
  const _NotificationSection();

  @override
  State<_NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<_NotificationSection> {
  bool _dailyReminder = false;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Notificaciones',
            icon: Icons.notifications_active_rounded,
          ),
          SwitchListTile(
            value: _dailyReminder,
            onChanged: _toggleReminder,
            activeTrackColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Recordatorio diario',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Recibe un aviso cada mañana para revisar tus turnos',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          GlassActionButton(
            label: 'Enviar prueba',
            icon: Icons.send_rounded,
            onTap: () async {
              await NotificationService.showTestNotification();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() => _dailyReminder = value);
    if (value) {
      await NotificationService.scheduleDailyReminder();
    } else {
      await NotificationService.cancelDailyReminder();
    }
  }
}
