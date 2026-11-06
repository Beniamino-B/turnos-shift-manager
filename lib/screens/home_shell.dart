import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/glass.dart';
import 'calendar_screen.dart';
import 'finance_screen.dart';
import 'settings_screen.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const BackgroundGradient(),
          IndexedStack(
            index: currentIndex,
            children: const [
              CalendarScreen(),
              FinanceScreen(),
              SettingsScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: GlassBottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) =>
              ref.read(currentTabProvider.notifier).state = index,
        ),
      ),
    );
  }
}
