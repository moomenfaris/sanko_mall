import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../navigation/home_shell.dart';

/// Application routes. The app starts directly in the guest home shell.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (_, __) => const HomeShell())],
  );
});
