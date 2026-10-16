import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/utils/price_formatter.dart';
import '../../scanner/data/models/product.dart';
import '../../scanner/presentation/product_provider.dart';
import '../data/models/cart_item.dart';
import 'cart_provider.dart';
import 'manual_picker_sheet.dart';

const _brand = Color(0xFF138A3B);
const _muted = Color(0xFF6B776F);
const _hairline = Color(0xFFE6ECE7);

/// Basket screen: summary header, scanned highlight, item lines and checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final count = ref.watch(cartCountProvider);
    final lastScanned = ref.watch(lastScannedProductProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      appBar: AppBar(
        title: Text(
          l.t('cart'),
          style: const TextStyle(
            color: _brand,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => ManualPickerSheet.show(context),
            style: FilledButton.styleFrom(
              backgroundColor: _brand,
              foregroundColor: Colors.white,
            ),
            child: Text(l.t('shortcuts')),
          ),
          if (items.isNotEmpty)
            IconButton(
              tooltip: l.t('clear_cart'),
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SummaryCard(total: total, count: count),
          if (lastScanned != null) ...[
            const SizedBox(height: 12),
            _LastScannedCard(product: lastScanned, label: l.t('last_scanned')),
          ],
          const SizedBox(height: 18),
          Text(
            l.t('selected_products'),
            style: const TextStyle(
              color: Color(0xFF3C4A41),
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            _EmptyCart(message: l.t('cart_empty'), cta: l.t('shortcuts'))
          else
            for (final item in items) ...[
              _CartLine(item: item),
              const SizedBox(height: 10),
            ],
        ],
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _CheckoutBar(total: total, label: l.t('total')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17A04A), Color(0xFF0F6E30)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.t('basket_summary'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    PriceFormatter.format(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l.t('items_count')}: $count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.shopping_cart_rounded,
            color: Colors.white,
            size: 46,
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.message, required this.cta});

  final String message;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _hairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 56,
            color: Color(0xFFB6C2BA),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ManualPickerSheet.show(context),
            style: FilledButton.styleFrom(
              backgroundColor: _brand,
              foregroundColor: Colors.white,
            ),
            child: Text(cta),
          ),
        ],
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: Color(0xFFF1F5F1),
      child: Icon(Icons.shopping_basket_outlined, color: _muted),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: size,
        height: size,
        child: url.isEmpty
            ? placeholder
            : Image.network(
                url,
                headers: AppConstants.barcodeImageHeaders,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

class _CartLine extends ConsumerWidget {
  const _CartLine({required this.item});
  final CartItem item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final notifier = ref.read(cartProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _hairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductThumb(url: item.product.imageUrl, size: 58),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name(l.isRtl),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.unitName} · ${PriceFormatter.format(item.unitPrice)}',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.t('remove'),
                onPressed: () => notifier.remove(item),
                icon: const Icon(Icons.close_rounded, size: 20),
                color: _muted,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StepperControl(
                quantity: item.quantity,
                onIncrement: () => notifier.increment(item),
                onDecrement: () => notifier.decrement(item),
              ),
              const Spacer(),
              Text(
                PriceFormatter.format(item.total),
                style: const TextStyle(
                  color: _brand,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperControl extends StatelessWidget {
  const _StepperControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
          SizedBox(
            width: 34,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(icon, size: 18, color: _brand),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total, required this.label});
  final double total;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        PriceFormatter.format(total),
                        style: const TextStyle(
                          color: _brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
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

class _LastScannedCard extends StatelessWidget {
  const _LastScannedCard({required this.product, required this.label});

  final Product product;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context).isRtl;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9FD8B2)),
      ),
      child: Row(
        children: [
          _ProductThumb(url: product.imageUrl, size: 58),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF2E7D46),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name(isArabic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  product.barcode,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            PriceFormatter.format(product.singlePrice),
            style: const TextStyle(color: _brand, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
