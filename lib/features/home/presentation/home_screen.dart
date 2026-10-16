import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/utils/price_formatter.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../scanner/presentation/product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    required this.onOpenOffers,
    required this.onJumpToScan,
  });

  final VoidCallback onOpenOffers;
  final VoidCallback onJumpToScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final total = ref.watch(cartTotalProvider);
    final count = ref.watch(cartCountProvider);
    final products = ref
        .watch(latestProductsProvider)
        .maybeWhen(data: (data) => data, orElse: () => const []);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('home'))),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF7EE), Color(0xFFF7F8F5)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF148C3E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x35148C3E),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.t('cart_total'),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            PriceFormatter.format(total),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l.t('items_count')} $count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart_checkout_rounded,
                      size: 54,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onJumpToScan,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(l.t('scan_product')),
              ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: l.t('quick_shortcuts'),
                actionLabel: l.t('view_all'),
                onTap: onOpenOffers,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuickTile(
                    icon: Icons.local_offer_outlined,
                    label: l.t('special_offers'),
                    onTap: onOpenOffers,
                  ),
                  _QuickTile(
                    icon: Icons.qr_code_2_rounded,
                    label: l.t('scan_product'),
                    onTap: onJumpToScan,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SectionTitle(title: l.t('latest_products')),
              const SizedBox(height: 10),
              for (final product in products.take(4))
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          product.name(l.isRtl),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        PriceFormatter.format(product.singlePrice),
                        style: const TextStyle(
                          color: Color(0xFF148C3E),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        tooltip: l.t('add_to_cart'),
                        onPressed: () {
                          ref.read(cartProvider.notifier).add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF148C3E),
                              content: Text(
                                l
                                    .t('cart_product_added')
                                    .replaceFirst(
                                      '{product}',
                                      product.name(l.isRtl),
                                    ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF148C3E),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({this.onTap, required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (actionLabel != null)
          TextButton(onPressed: onTap, child: Text(actionLabel!)),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 52) / 3,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF148C3E)),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
