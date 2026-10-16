import 'package:equatable/equatable.dart';

/// Available unit types for a product line.
enum ItemType { unit1, unit2, unit3, unit4 }

/// A sellable product. Supports up to 4 unit/price options.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.barcode,
    required this.nameEn,
    required this.nameAr,
    required this.price1,
    required this.price2,
    required this.price3,
    required this.price4,
    required this.unit1,
    required this.unit2,
    required this.unit3,
    required this.unit4,
    required this.unitsPerCarton,
    required this.imageUrl,
    required this.category,
    this.oldPrice,
  });

  final String id;
  final String barcode;
  final String nameEn;
  final String nameAr;
  final double price1;
  final double price2;
  final double price3;
  final double price4;
  final String unit1;
  final String unit2;
  final String unit3;
  final String unit4;
  final int unitsPerCarton;
  final String imageUrl;
  final String category;
  final double? oldPrice;

  double get singlePrice => price1;
  double get cartonPrice => price2;

  double priceForType(ItemType type) {
    switch (type) {
      case ItemType.unit1:
        return price1;
      case ItemType.unit2:
        return price2;
      case ItemType.unit3:
        return price3;
      case ItemType.unit4:
        return price4;
    }
  }

  String unitForType(ItemType type) {
    switch (type) {
      case ItemType.unit1:
        return unit1;
      case ItemType.unit2:
        return unit2;
      case ItemType.unit3:
        return unit3;
      case ItemType.unit4:
        return unit4;
    }
  }

  List<ItemType> get availableTypes {
    final all = [
      ItemType.unit1,
      ItemType.unit2,
      ItemType.unit3,
      ItemType.unit4,
    ];
    final filtered = all
        .where((type) => unitForType(type).trim().isNotEmpty)
        .toList();
    return filtered.isEmpty ? const [ItemType.unit1] : filtered;
  }

  static double _parsePrice(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final normalized = value.replaceAll(',', '').trim();
      return double.tryParse(normalized) ?? 0;
    }
    return 0;
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    barcode: json['barcode'] as String,
    nameEn: json['nameEn'] as String,
    nameAr: json['nameAr'] as String,
    price1: _parsePrice(json['price1'] ?? json['singlePrice']),
    price2: _parsePrice(json['price2'] ?? json['cartonPrice']),
    price3: _parsePrice(json['price3']),
    price4: _parsePrice(json['price4'] ?? json['peice4'] ?? json['piece4']),
    unit1: (json['unit1'] as String?)?.trim().isNotEmpty == true
        ? (json['unit1'] as String).trim()
        : 'Single',
    unit2: (json['unit2'] as String?)?.trim().isNotEmpty == true
        ? (json['unit2'] as String).trim()
        : 'Carton',
    unit3: (json['unit3'] as String?)?.trim() ?? '',
    unit4: (json['unit4'] as String?)?.trim() ?? '',
    unitsPerCarton: (json['unitsPerCarton'] as num?)?.toInt() ?? 1,
    imageUrl: json['imageUrl'] as String,
    category: json['category'] as String,
  );

  factory Product.fromBarcodeApiJson({
    required Map<String, dynamic> data,
    required String barcode,
  }) {
    final unit1 = (data['unit1'] as String?)?.trim() ?? '';
    final unit2 = (data['unit2'] as String?)?.trim() ?? '';
    final unit3 = (data['unit3'] as String?)?.trim() ?? '';
    final unit4 = (data['unit4'] as String?)?.trim() ?? '';
    return Product(
      id: '${data['id']}',
      barcode: barcode,
      nameEn: data['name_m'] as String? ?? 'Unknown product',
      nameAr: data['name_m'] as String? ?? 'منتج غير معروف',
      price1: _parsePrice(data['price1']),
      price2: _parsePrice(data['price2']),
      price3: _parsePrice(data['price3']),
      price4: _parsePrice(data['price4'] ?? data['peice4'] ?? data['piece4']),
      unit1: unit1,
      unit2: unit2,
      unit3: unit3,
      unit4: unit4,
      unitsPerCarton: 1,
      imageUrl: data['imageUrl'] as String? ?? data['mageUrl'] as String? ?? '',
      category: 'General',
      oldPrice: _parsePrice(data['oldPrice']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'barcode': barcode,
    'nameEn': nameEn,
    'nameAr': nameAr,
    'price1': price1,
    'price2': price2,
    'price3': price3,
    'price4': price4,
    'unit1': unit1,
    'unit2': unit2,
    'unit3': unit3,
    'unit4': unit4,
    'unitsPerCarton': unitsPerCarton,
    'imageUrl': imageUrl,
    'category': category,
  };

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [id, barcode];
}
