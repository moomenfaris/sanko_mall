import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/service_locator.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => sl<ProductRepository>(),
);

/// All products, used by the manual-selection list in the cart.
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final result = await ref.watch(productRepositoryProvider).getShortcuts();
  return result.when(
    success: (d) => d,
    failure: (f) => throw Exception(f.message),
  );
});

/// Most recently added products displayed on the home screen.
final latestProductsProvider = FutureProvider<List<Product>>((ref) async {
  final result = await ref
      .watch(productRepositoryProvider)
      .getLatestMaterials();
  return result.when(
    success: (d) => d,
    failure: (f) => throw Exception(f.message),
  );
});

/// Products currently available in the special-offers tab.
final offersProvider = FutureProvider<List<Product>>((ref) async {
  final result = await ref.watch(productRepositoryProvider).getOffers();
  return result.when(
    success: (d) => d,
    failure: (f) => throw Exception(f.message),
  );
});

/// Looks up a product by barcode. Returns null when not found.
final productByBarcodeProvider = FutureProvider.family<Product?, String>((
  ref,
  barcode,
) async {
  final result = await ref
      .watch(productRepositoryProvider)
      .getByBarcode(barcode);
  return result.dataOrNull;
});

/// Searches products by text via the barcode search API.
final productsBySearchTextProvider = FutureProvider.family
    .autoDispose<List<Product>, String>((ref, query) async {
      final term = query.trim();
      if (term.isEmpty) return const [];

      final result = await ref
          .watch(productRepositoryProvider)
          .searchByText(term);

      return result.when(
        success: (d) => d,
        failure: (f) => throw Exception(f.message),
      );
    });

/// Most recently scanned product, highlighted at the top of the cart.
final lastScannedProductProvider = StateProvider<Product?>((ref) => null);
