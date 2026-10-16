import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_localizations.dart';
import '../../features/cart/presentation/cart_provider.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import 'tab_provider.dart';

/// Bottom-navigation shell hosting the redesigned five primary tabs.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  void _selectTab(int index) =>
      ref.read(selectedTabProvider.notifier).state = index;

  void _openOffers() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OffersScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final index = ref.watch(selectedTabProvider);
    final cartCount = ref.watch(cartCountProvider);
    final pages = [
      const CartScreen(),
      const ScannerScreen(),
      const SearchScreen(),
      HomeScreen(
        onOpenOffers: _openOffers,
        onJumpToScan: () => _selectTab(ShellTabs.scanner),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          heroTag: 'shell_scan_fab',
          elevation: 0,
          backgroundColor: const Color(0xFF138A3B),
          onPressed: () => _selectTab(ShellTabs.scanner),
          child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 74,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              _BottomItem(
                selected: index == ShellTabs.cart,
                icon: Icons.shopping_cart_outlined,
                badgeCount: cartCount,
                label: l.t('cart'),
                onTap: () => _selectTab(ShellTabs.cart),
              ),
              const SizedBox(width: 70),
              _BottomItem(
                selected: index == ShellTabs.search,
                icon: Icons.search_rounded,
                label: l.t('search'),
                onTap: () => _selectTab(ShellTabs.search),
              ),
              _BottomItem(
                selected: index == ShellTabs.home,
                icon: Icons.home_outlined,
                label: l.t('home'),
                onTap: () => _selectTab(ShellTabs.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF138A3B) : const Color(0xFF748079);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: (badgeCount ?? 0) > 0,
              label: Text('${badgeCount ?? 0}'),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
