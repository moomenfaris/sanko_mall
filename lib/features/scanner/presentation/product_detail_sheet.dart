import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/navigation/tab_provider.dart';
import '../../../shared/utils/price_formatter.dart';
import '../../../shared/widgets/quantity_selector.dart';
import '../../cart/presentation/cart_provider.dart';
import '../data/models/product.dart';
import 'product_provider.dart';

/// Bottom sheet shown after a scan or manual pick: product info, type, qty,
/// and add-to-cart. Reused by both the scanner and manual-selection flows.
class ProductDetailSheet extends ConsumerStatefulWidget {
  const ProductDetailSheet({super.key, required this.product});

  final Product product;

  static Future<void> show(BuildContext context, Product product) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ProductDetailSheet(product: product),
    );
  }

  @override
  ConsumerState<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends ConsumerState<ProductDetailSheet> {
  late ItemType _type;
  int _qty = 1;

  double get _unitPrice => widget.product.priceForType(_type);

  @override
  void initState() {
    super.initState();
    _type = widget.product.availableTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isAr = l.isRtl;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset =
        mediaQuery.viewInsets.bottom > mediaQuery.viewPadding.bottom
        ? mediaQuery.viewInsets.bottom
        : mediaQuery.viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              widget.product.imageUrl,
              headers: AppConstants.barcodeImageHeaders,
              height: 160,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.name(isAr),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            '${l.t('barcode')}: ${widget.product.barcode}',
            style: const TextStyle(
              color: Color(0xFF5F6F65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            PriceFormatter.format(_unitPrice),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: const Color(0xFF138A3B)),
          ),
          const SizedBox(height: 16),
          SegmentedButton<ItemType>(
            segments: [
              for (final type in widget.product.availableTypes)
                ButtonSegment(
                  value: type,
                  label: Text(widget.product.unitForType(type)),
                ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.t('quantity')),
              QuantitySelector(
                quantity: _qty,
                onIncrement: () => setState(() => _qty++),
                onDecrement: () => setState(() => _qty--),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              '${l.t('add_to_cart')}  •  '
              '${PriceFormatter.format(_unitPrice * _qty)}',
            ),
            onPressed: () {
              ref
                  .read(cartProvider.notifier)
                  .add(widget.product, type: _type, qty: _qty);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF148C3E),
                  content: Text(
                    l.t('cart_item_added'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
              ref.read(lastScannedProductProvider.notifier).state =
                  widget.product;
              Navigator.of(context).pop();
              ref.read(selectedTabProvider.notifier).state = ShellTabs.cart;
            },
          ),
        ],
      ),
    );
  }
}
