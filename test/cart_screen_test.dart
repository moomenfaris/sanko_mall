import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanko_mall/core/config/app_theme.dart';
import 'package:sanko_mall/core/localization/app_localizations.dart';
import 'package:sanko_mall/features/cart/presentation/cart_provider.dart';
import 'package:sanko_mall/features/cart/presentation/cart_screen.dart';
import 'package:sanko_mall/features/scanner/data/models/product.dart';

void main() {
  testWidgets('cart screen renders with an item', (tester) async {
    final product = Product.fromBarcodeApiJson(
      data: const {
        'id': 669,
        'name_m': 'نايلون شفاف فالكوم 30سم',
        'price1': 2000.000,
        'price2': 36000.000,
        'price3': 0.000,
        'price4': 0.000,
        'unit1': 'قطعة',
        'unit2': 'ربطة',
        'unit3': '',
        'unit4': '',
        'imageUrl':
            'http://sanko.ideavsion.online:7777/api/Search/image/x.webp',
      },
      barcode: '6291041500213',
    );

    final container = ProviderContainer();
    container.read(cartProvider.notifier).add(product, type: ItemType.unit1);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ar'),
          theme: AppTheme.light,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const CartScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text(product.nameAr), findsWidgets);
    expect(find.text('السلة'), findsOneWidget);

    // The cart list should remain visible and not be pushed out of view.
    final screen = tester.getSize(find.byType(CartScreen));
    final listTop = tester.getTopLeft(find.byType(ListView)).dy;
    expect(listTop, lessThan(screen.height / 2));
  });
}
