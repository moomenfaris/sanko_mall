import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../shared/utils/price_formatter.dart';
import '../../../shared/widgets/state_views.dart';
import '../../scanner/presentation/product_detail_sheet.dart';
import '../../scanner/presentation/product_provider.dart';

/// Modal list to add a product to the cart without scanning a barcode.
class ManualPickerSheet extends ConsumerWidget {
  const ManualPickerSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const ManualPickerSheet(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final products = ref.watch(allProductsProvider);
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: products.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorStateView(message: '$e'),
          data: (list) => ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final p = list[i];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    p.imageUrl,
                    headers: AppConstants.barcodeImageHeaders,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.shopping_basket),
                  ),
                ),
                title: Text(p.name(l.isRtl)),
                subtitle: Text(PriceFormatter.format(p.singlePrice)),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {
                  Navigator.of(context).pop();
                  ProductDetailSheet.show(context, p);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
