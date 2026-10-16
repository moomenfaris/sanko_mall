import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index of the active tab in [HomeShell]; shared so features can switch tabs.
final selectedTabProvider = StateProvider<int>((ref) => 3);

class ShellTabs {
  ShellTabs._();

  static const int cart = 0;
  static const int scanner = 1;
  static const int search = 2;
  static const int home = 3;
}
