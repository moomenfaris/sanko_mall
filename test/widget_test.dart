// Unit tests for Sanko Mall cart and product domain models.

import 'package:flutter_test/flutter_test.dart';

import 'package:sanko_mall/features/cart/data/models/cart_item.dart';
import 'package:sanko_mall/features/scanner/data/models/product.dart';

const _product = Product(
  id: 'p001',
  barcode: '123',
  nameEn: 'Milk',
  nameAr: 'حليب',
  singlePrice: 1.5,
  cartonPrice: 17,
  unitsPerCarton: 12,
  imageUrl: '',
  category: 'Dairy',
);

void main() {
  test('single item total uses single price', () {
    const item = CartItem(
      product: _product,
      type: ItemType.single,
      quantity: 2,
    );
    expect(item.total, 3.0);
  });

  test('carton item total uses carton price', () {
    const item = CartItem(
      product: _product,
      type: ItemType.carton,
      quantity: 2,
    );
    expect(item.total, 34.0);
  });

  test('product localizes name', () {
    expect(_product.name(true), 'حليب');
    expect(_product.name(false), 'Milk');
  });
}
