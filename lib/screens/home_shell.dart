import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/glass.dart';
import '../widgets/summary_card.dart';
import 'calendar_screen.dart';
import 'finance_screen.dart';
import 'settings_screen.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);
    final summaryVisible = ref.watch(summaryVisibleProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    const screens = [
      CalendarScreen(),
      FinanceScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const BackgroundGradient(),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, animation) {
                final offset = Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offset, child: child),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(currentIndex),
                child: screens[currentIndex],
              ),
            ),
          ),
          if (currentIndex == 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomInset + kBottomNavHeight + 8,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                offset: summaryVisible ? Offset.zero : const Offset(0, 1.4),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 240),
                  opacity: summaryVisible ? 1 : 0,
                  child: const SummaryCard(),
                ),
              ),
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
