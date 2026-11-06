import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'providers/providers.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  final container = ProviderContainer();
  await seedDefaults(container.read(databaseProvider));
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TurnosApp(),
    ),
  );
}

class TurnosApp extends ConsumerWidget {
  const TurnosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final onboardingDone = ref.watch(onboardingDoneProvider);

    return MaterialApp(
      title: 'Turnos',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      home: onboardingDone ? const HomeShell() : const OnboardingScreen(),
    );
  }
}
