import 'package:equatable/equatable.dart';

import '../../../scanner/data/models/product.dart';

/// One line in the shopping cart: a product, a unit type and a quantity.
class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.type,
    required this.quantity,
  });

  final Product product;
  final ItemType type;
  final int quantity;

  /// Price of a single unit of the chosen [type].
  double get unitPrice => product.priceForType(type);

  /// Display name of the chosen unit.
  String get unitName {
    final label = product.unitForType(type).trim();
    return label.isEmpty ? type.name : label;
  }

  /// Total for this line (unit price × quantity).
  double get total => unitPrice * quantity;

  CartItem copyWith({ItemType? type, int? quantity}) => CartItem(
    product: product,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [product.id, type, quantity];
}
