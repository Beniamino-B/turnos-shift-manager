import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/settings_common.dart';

const List<String> _shiftPalette = [
  '#5B5FEF',
  '#FF9F43',
  '#7C3AED',
  '#22C55E',
  '#EF4444',
  '#0EA5E9',
  '#EC4899',
  '#F59E0B',
  '#14B8A6',
  '#8B5CF6',
  '#F43F5E',
  '#84CC16',
  '#06B6D4',
  '#6366F1',
  '#A855F7',
  '#78716C',
];

class ShiftConfigScreen extends ConsumerWidget {
  const ShiftConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final shifts = ref.watch(shiftsProvider).valueOrNull ?? const <Shift>[];

    return SettingsScaffold(
      title: 'Tipos de turno',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          SectionCard(
            title: 'Turnos configurados',
            children: [
              for (final shift in shifts) _shiftTile(context, ref, shift, palette),
              const SizedBox(height: 8),
              GlassActionButton(
                label: 'Nuevo turno',
                icon: Icons.add_rounded,
                onTap: () => _showShiftEditor(context, null),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shiftTile(
      BuildContext context, WidgetRef ref, Shift shift, AppPalette palette) {
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  shift.isRestDay
                      ? 'Descanso'
                      : '${shift.startTime} - ${shift.endTime}  •  ${shift.abbreviation}',
                  style: TextStyle(
                    fontSize: 12,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (shift.isNightShift)
            _badge('Nocturno', AppColors.night),
          if (shift.isRestDay)
            _badge('Descanso', palette.textSecondary),
          IconButton(
            icon: Icon(Icons.edit_rounded,
                color: palette.textSecondary, size: 20),
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

  Widget _badge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
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
  late bool _rest;
  late bool _sunday;
  late bool _holiday;
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
    _rest = shift?.isRestDay ?? false;
    _sunday = shift?.appliesSundaySurcharge ?? true;
    _holiday = shift?.appliesHolidaySurcharge ?? true;
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
    final palette = AppPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        color: palette.surface,
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
                    color: palette.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.shift == null ? 'Nuevo turno' : 'Editar turno',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _abbrController,
                      decoration: const InputDecoration(labelText: 'Abrev.'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!_rest)
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
                value: _rest,
                onChanged: (value) => setState(() => _rest = value),
                activeTrackColor: palette.textSecondary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Día de descanso',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              if (!_rest) ...[
                SwitchListTile(
                  value: _night,
                  onChanged: (value) => setState(() => _night = value),
                  activeTrackColor: AppColors.night,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Turno nocturno',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                SwitchListTile(
                  value: _sunday,
                  onChanged: (value) => setState(() => _sunday = value),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Aplica recargo dominical',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                SwitchListTile(
                  value: _holiday,
                  onChanged: (value) => setState(() => _holiday = value),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Aplica recargo festivo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Color',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final hex in _shiftPalette)
                    GestureDetector(
                      onTap: () => setState(() => _colorHex = hex),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorFromHex(hex),
                          shape: BoxShape.circle,
                          border: _colorHex == hex
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: _colorHex == hex
                              ? [
                                  BoxShadow(
                                    color: colorFromHex(hex)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _pickCustomColor,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const SweepGradient(
                          colors: [
                            Color(0xFFFF0000),
                            Color(0xFFFFFF00),
                            Color(0xFF00FF00),
                            Color(0xFF00FFFF),
                            Color(0xFF0000FF),
                            Color(0xFFFF00FF),
                            Color(0xFFFF0000),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 18),
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

  Future<void> _pickCustomColor() async {
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _ColorPickerDialog(initialHex: _colorHex),
    );
    if (result != null && mounted) {
      setState(() => _colorHex = result);
    }
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
      isRestDay: Value(_rest),
      appliesSundaySurcharge: Value(_sunday),
      appliesHolidaySurcharge: Value(_holiday),
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

class _ColorPickerDialog extends StatefulWidget {
  final String initialHex;

  const _ColorPickerDialog({required this.initialHex});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(colorFromHex(widget.initialHex));
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }

  @override
  Widget build(BuildContext context) {
    final color = HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor();
    return AlertDialog(
      title: const Text('Color personalizado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),
          const SizedBox(height: 16),
          _slider('Tono', _hue, 0, 360, (v) => setState(() => _hue = v)),
          _slider('Saturación', _saturation, 0, 1,
              (v) => setState(() => _saturation = v)),
          _slider('Brillo', _value, 0, 1, (v) => setState(() => _value = v)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(colorToHex(color)),
          child: const Text('Elegir'),
        ),
      ],
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
