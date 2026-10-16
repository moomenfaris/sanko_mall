import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/utils/price_formatter.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../scanner/data/models/product.dart';
import '../../scanner/presentation/product_provider.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final products = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('special_offers'))),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                height: 170,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B9F49), Color(0xFF0D6E33)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.t('weekly_offers'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            '30%',
                            style: TextStyle(
                              color: Color(0xFFFFD84D),
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            l.t('offers'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.local_mall_rounded,
                      color: Colors.white,
                      size: 74,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < list.length; i++) ...[
                _OfferRow(
                  index: i,
                  product: list[i],
                  isRtl: l.isRtl,
                  onAdd: () {
                    ref.read(cartProvider.notifier).add(list[i]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF148C3E),
                        content: Text(
                          l
                              .t('cart_product_added')
                              .replaceFirst('{product}', list[i].name(l.isRtl)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OfferRow extends StatelessWidget {
  const _OfferRow({
    required this.index,
    required this.product,
    required this.isRtl,
    required this.onAdd,
  });

  final int index;
  final Product product;
  final bool isRtl;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final name = product.name(isRtl);
    final price = product.singlePrice;
    final discount = 8 + (index * 3);
    final oldPrice = (product.oldPrice != null && product.oldPrice! > price)
        ? product.oldPrice!
        : price * (1 + discount / 100);
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      PriceFormatter.format(price),
                      style: const TextStyle(
                        color: Color(0xFF138A3B),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      PriceFormatter.format(oldPrice),
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${math.min(discount, 30)}%-',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: onAdd,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF148C3E),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
