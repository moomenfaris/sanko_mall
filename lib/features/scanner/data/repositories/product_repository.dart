import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../models/product.dart';

/// Source of product data. Mock branch loads bundled JSON; real branch hits
/// the backend via [ApiClient]. Repositories isolate that decision from UI.
abstract interface class ProductRepository {
  Future<Result<List<Product>>> getAll();
  Future<Result<List<Product>>> getShortcuts();
  Future<Result<List<Product>>> getLatestMaterials();
  Future<Result<List<Product>>> getOffers();
  Future<Result<Product>> getByBarcode(String barcode);
  Future<Result<List<Product>>> searchByText(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._client);

  // ignore: unused_field
  final ApiClient _client;
  List<Product>? _cache;

  Future<List<Product>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(AppConstants.mockProducts);
    final list = (jsonDecode(raw) as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = list;
    return list;
  }

  @override
  Future<Result<List<Product>>> getAll() async {
    try {
      if (AppConstants.useMockData) return Success(await _load());
      final res = await _client.dio.get('/products');
      return Success(
        (res.data as List)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      return const Err(ServerFailure('Failed to load products.'));
    }
  }

  @override
  Future<Result<List<Product>>> getShortcuts() async {
    try {
      final res = await _client.dio.get(
        '${AppConstants.barcodeLookupBaseUrl}${AppConstants.shortcutsPath}',
        options: Options(
          headers: {'x-api-key': AppConstants.barcodeLookupApiKey},
        ),
      );
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      if (body['success'] != true || data is! List) {
        return const Err(ServerFailure('Failed to load shortcut products.'));
      }

      return Success(
        data
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => Product.fromBarcodeApiJson(
                data: item,
                barcode: '${item['barcode'] ?? item['id'] ?? ''}',
              ),
            )
            .toList(),
      );
    } catch (_) {
      return const Err(ServerFailure('Failed to load shortcut products.'));
    }
  }

  @override
  Future<Result<List<Product>>> getLatestMaterials() async {
    try {
      final res = await _client.dio.get(
        '${AppConstants.barcodeLookupBaseUrl}${AppConstants.latestMaterialsPath}',
        options: Options(
          headers: {'x-api-key': AppConstants.barcodeLookupApiKey},
        ),
      );
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      if (body['success'] != true || data is! List) {
        return const Err(ServerFailure('Failed to load latest products.'));
      }

      return Success(
        data
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => Product.fromBarcodeApiJson(
                data: item,
                barcode: '${item['barcode'] ?? item['id'] ?? ''}',
              ),
            )
            .toList(),
      );
    } catch (_) {
      return const Err(ServerFailure('Failed to load latest products.'));
    }
  }

  @override
  Future<Result<List<Product>>> getOffers() async {
    try {
      final res = await _client.dio.get(
        '${AppConstants.barcodeLookupBaseUrl}${AppConstants.offersPath}',
        options: Options(
          headers: {'x-api-key': AppConstants.barcodeLookupApiKey},
        ),
      );
      final body = res.data as Map<String, dynamic>;
      final data = body['data'];
      if (body['success'] != true || data is! List) {
        return const Err(ServerFailure('Failed to load offers.'));
      }

      return Success(
        data
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => Product.fromBarcodeApiJson(
                data: item,
                barcode: '${item['barcode'] ?? item['id'] ?? ''}',
              ),
            )
            .toList(),
      );
    } catch (_) {
      return const Err(ServerFailure('Failed to load offers.'));
    }
  }

  @override
  Future<Result<Product>> getByBarcode(String barcode) async {
    try {
      // Camera barcode scan is intentionally offline-only.
      final products = await _load();
      final match = products.where((p) => p.barcode == barcode);
      if (match.isEmpty) return const Err(NotFoundFailure());
      return Success(match.first);
    } catch (_) {
      return const Err(ServerFailure());
    }
  }

  @override
  Future<Result<List<Product>>> searchByText(String query) async {
    try {
      final encoded = Uri.encodeComponent(query.trim());
      final res = await _client.dio.get(
        '${AppConstants.barcodeLookupBaseUrl}/api/Search/$encoded',
        options: Options(
          headers: {'x-api-key': AppConstants.barcodeLookupApiKey},
        ),
      );
      final body = res.data as Map<String, dynamic>;
      final success = body['success'] == true;
      final data = body['data'];
      if (!success || data is! List) {
        return const Err(NotFoundFailure());
      }

      final products = data
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => Product.fromBarcodeApiJson(
              data: item,
              barcode: '${item['barcode'] ?? ''}',
            ),
          )
          .toList();

      return Success(products);
    } catch (_) {
      return const Err(ServerFailure('Failed to search products.'));
    }
  }
}
