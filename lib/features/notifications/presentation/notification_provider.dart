import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/service_locator.dart';
import '../data/models/app_notification.dart';
import '../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => sl<NotificationRepository>(),
);

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final result = await ref.watch(notificationRepositoryProvider).getAll();
  return result.when(
    success: (d) => d,
    failure: (f) => throw Exception(f.message),
  );
});

/// Count of unread notifications for the bottom-nav badge.
final unreadCountProvider = Provider<int>((ref) {
  final async = ref.watch(notificationsProvider);
  return async.maybeWhen(
    data: (list) => list.where((n) => !n.read).length,
    orElse: () => 0,
  );
});
