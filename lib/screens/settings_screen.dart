import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/settings_common.dart';
import 'payment_config_screen.dart';
import 'payroll_config_screen.dart';
import 'shift_config_screen.dart';
import 'theme_config_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
      children: [
        const SizedBox(height: 8),
        const _TitleBar(),
        const SizedBox(height: 14),
        SectionCard(
          title: 'Preferencias',
          children: [
            SettingsTile(
              icon: Icons.account_balance_wallet_rounded,
              title: 'Configuración de nómina',
              subtitle: 'Salario, transporte, salud y recargos',
              onTap: () => _push(context, const PayrollConfigScreen()),
            ),
            SettingsTile(
              icon: Icons.event_available_rounded,
              title: 'Fechas de pago',
              subtitle: 'Frecuencia, cortes y días de pago',
              onTap: () => _push(context, const PaymentConfigScreen()),
            ),
            SettingsTile(
              icon: Icons.work_outline_rounded,
              title: 'Tipos de turno',
              subtitle: 'Horarios, colores y reglas de recargo',
              onTap: () => _push(context, const ShiftConfigScreen()),
            ),
            SettingsTile(
              icon: Icons.palette_rounded,
              title: 'Tema',
              subtitle: 'Claro, oscuro o según el sistema',
              onTap: () => _push(context, const ThemeConfigScreen()),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _NotificationSection(),
      ],
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 26,
      child: Row(
        children: [
          const Icon(Icons.settings_rounded,
              color: AppColors.primary, size: 26),
          const SizedBox(width: 10),
          Text(
            'Ajustes',
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

class _NotificationSection extends StatefulWidget {
  const _NotificationSection();

  @override
  State<_NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<_NotificationSection> {
  bool _dailyReminder = false;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return GlassContainer(
      borderRadius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notificaciones',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          SwitchListTile(
            value: _dailyReminder,
            onChanged: _toggleReminder,
            activeTrackColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Recordatorio diario',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            subtitle: Text(
              'Recibe un aviso cada mañana para revisar tus turnos',
              style: TextStyle(fontSize: 11, color: palette.textSecondary),
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
