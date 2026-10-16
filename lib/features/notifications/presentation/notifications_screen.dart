import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/utils/price_formatter.dart';
import '../data/models/app_notification.dart';
import '../../../shared/widgets/state_views.dart';
import '../../scanner/data/models/product.dart';
import '../../cart/presentation/cart_provider.dart';
import 'notification_provider.dart';
import '../../scanner/presentation/product_provider.dart';

/// Notifications and special offers in separate tabs.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final notifications = ref.watch(notificationsProvider);
    final offers = ref.watch(offersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.t('notifications')),
          bottom: TabBar(
            tabs: [
              Tab(text: l.t('notifications')),
              Tab(text: l.t('special_offers')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _NotificationsTab(
              async: notifications,
              isArabic: l.isRtl,
              onRetry: () => ref.invalidate(notificationsProvider),
            ),
            _OffersTab(async: offers, isArabic: l.isRtl),
          ],
        ),
      ),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab({
    required this.async,
    required this.isArabic,
    required this.onRetry,
  });

  final AsyncValue<List<AppNotification>> async;
  final bool isArabic;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorStateView(message: '$e', onRetry: onRetry),
      data: (list) {
        if (list.isEmpty) {
          return EmptyStateView(
            icon: Icons.notifications_off_outlined,
            message: AppLocalizations.of(context).t('no_notifications'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) =>
              _NotificationCard(item: list[i], index: i, isArabic: isArabic),
        );
      },
    );
  }
}

class _OffersTab extends ConsumerWidget {
  const _OffersTab({required this.async, required this.isArabic});

  final AsyncValue<List<Product>> async;
  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return async.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorStateView(message: '$e'),
      data: (list) {
        if (list.isEmpty) {
          return EmptyStateView(
            icon: Icons.local_offer_outlined,
            message: AppLocalizations.of(context).t('no_notifications'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final product = list[i];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      headers: AppConstants.barcodeImageHeaders,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name(isArabic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          PriceFormatter.format(product.singlePrice),
                          style: const TextStyle(
                            color: Color(0xFF138A3B),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (product.oldPrice != null &&
                            product.oldPrice! > product.singlePrice) ...[
                          const SizedBox(height: 2),
                          Text(
                            PriceFormatter.format(product.oldPrice!),
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton.filled(
                    tooltip: AppLocalizations.of(context).t('add_to_cart'),
                    onPressed: () {
                      ref.read(cartProvider.notifier).add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF148C3E),
                          content: Text(
                            AppLocalizations.of(context).t('cart_item_added'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF138A3B),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.index,
    required this.isArabic,
  });

  final AppNotification item;
  final int index;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final swatch = [
      const Color(0xFFFFE9E8),
      const Color(0xFFFFF1D8),
      const Color(0xFFE5F6E8),
      const Color(0xFFEAF1FF),
      const Color(0xFFF0E9FF),
    ];
    final icons = [
      Icons.percent_rounded,
      Icons.local_offer_rounded,
      Icons.new_releases_outlined,
      Icons.notifications_active_outlined,
      Icons.card_giftcard_rounded,
    ];
    final tileColor = swatch[index % swatch.length];
    final icon = icons[index % icons.length];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF138A3B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title(isArabic),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body(isArabic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF68746D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (!item.read)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A5F),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
