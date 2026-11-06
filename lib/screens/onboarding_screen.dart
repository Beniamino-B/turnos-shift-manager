import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../domain/formatters.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _salaryController = TextEditingController();
  int _page = 0;
  String _themeMode = 'system';

  @override
  void dispose() {
    _pageController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _page == 0
                        ? const SizedBox.shrink()
                        : TextButton(
                            onPressed: _finish,
                            child: const Text('Omitir'),
                          ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => setState(() => _page = index),
                    children: [
                      _welcomePage(palette),
                      _themePage(palette),
                      _salaryPage(palette),
                    ],
                  ),
                ),
                _dots(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: GlassActionButton(
                    label: _page == 2 ? 'Comenzar' : 'Siguiente',
                    icon: _page == 2
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomePage(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.night],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.calendar_month_rounded,
                color: Colors.white, size: 48),
          ),
          const SizedBox(height: 28),
          Text(
            'Bienvenido a Turnos',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Organiza tus turnos de trabajo y controla tu nómina, recargos y días de pago desde un solo lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _themePage(AppPalette palette) {
    final options = [
      ('light', 'Claro', Icons.light_mode_rounded),
      ('dark', 'Oscuro', Icons.dark_mode_rounded),
      ('system', 'Sistema', Icons.settings_suggest_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige tu tema',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          for (final option in options)
            GestureDetector(
              onTap: () {
                setState(() => _themeMode = option.$1);
                ref.read(setThemeModeProvider)(option.$1);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: _themeMode == option.$1
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _themeMode == option.$1
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(option.$3,
                        color: _themeMode == option.$1
                            ? AppColors.primary
                            : palette.textSecondary),
                    const SizedBox(width: 14),
                    Text(
                      option.$2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (_themeMode == option.$1)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _salaryPage(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu salario base',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Lo usamos para calcular tu pago por hora y tu nómina. Puedes cambiarlo luego en Ajustes.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Salario base (COP)',
              prefixIcon: Icon(Icons.payments_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dots() {
    final palette = AppPalette.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _page == i ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _page == i ? AppColors.primary : palette.glassBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final salary = parsePesosToCents(_salaryController.text);
    if (salary != null) {
      final config = ref.read(configProvider).valueOrNull;
      final db = ref.read(databaseProvider);
      if (config != null) {
        await (db.update(db.payrollConfigs)
              ..where((t) => t.id.equals(config.id)))
            .write(PayrollConfigsCompanion(baseSalary: Value(salary)));
      }
    }
    await ref.read(completeOnboardingProvider)();
  }
}
