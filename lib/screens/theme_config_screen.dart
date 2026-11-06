import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/settings_common.dart';

class ThemeConfigScreen extends ConsumerWidget {
  const ThemeConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final settings = ref.watch(appSettingsProvider).valueOrNull;
    final current = settings?.themeMode ?? 'system';

    final options = [
      ('light', 'Claro', Icons.light_mode_rounded),
      ('dark', 'Oscuro', Icons.dark_mode_rounded),
      ('system', 'Sistema', Icons.settings_suggest_rounded),
    ];

    return SettingsScaffold(
      title: 'Tema',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          SectionCard(
            title: 'Apariencia',
            children: [
              for (final option in options)
                GestureDetector(
                  onTap: () => ref.read(setThemeModeProvider)(option.$1),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: current == option.$1
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: current == option.$1
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.7),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(option.$3,
                            color: current == option.$1
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
                        if (current == option.$1)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
