import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../scanner/data/models/product.dart';
import '../data/models/cart_item.dart';

/// Fully functional cart logic. Keyed by product id + item type so the same
/// product can exist as both a single and a carton line. Emits a new
/// immutable list on every change for predictable, real-time price updates.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  String _key(String productId, ItemType type) => '$productId-${type.name}';

  void add(Product product, {ItemType type = ItemType.unit1, int qty = 1}) {
    final index = state.indexWhere(
      (i) => _key(i.product.id, i.type) == _key(product.id, type),
    );
    if (index == -1) {
      state = [...state, CartItem(product: product, type: type, quantity: qty)];
    } else {
      final updated = [...state];
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + qty,
      );
      state = updated;
    }
  }

  void setQuantity(CartItem item, int quantity) {
    if (quantity <= 0) return remove(item);
    state = [
      for (final i in state)
        if (i == item ||
            (i.product.id == item.product.id && i.type == item.type))
          i.copyWith(quantity: quantity)
        else
          i,
    ];
  }

  void increment(CartItem item) => setQuantity(item, item.quantity + 1);
  void decrement(CartItem item) => setQuantity(item, item.quantity - 1);

  void remove(CartItem item) {
    state = state
        .where((i) => !(i.product.id == item.product.id && i.type == item.type))
        .toList();
  }

  void clear() => state = const [];

  double get total => state.fold(0, (sum, i) => sum + i.total);
  int get count => state.fold(0, (sum, i) => sum + i.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

/// Derived total — recomputed automatically whenever the cart changes.
final cartTotalProvider = Provider<double>(
  (ref) => ref.watch(cartProvider).fold(0.0, (s, i) => s + i.total),
);

/// Derived item count for the bottom-nav badge.
final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).fold(0, (s, i) => s + i.quantity),
);
