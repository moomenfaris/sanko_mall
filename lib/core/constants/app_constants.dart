/// Global, compile-time application constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'سانكو مول';

  /// Base URL for the real backend. Mock layer is used until this is wired up.
  static const String baseUrl = 'https://api.sankomall.example.com';

  /// Barcode lookup endpoint used by the scanner.
  static const String barcodeLookupBaseUrl =
      'https://sanko.ideavsion.online:7777';
  static const String notificationsPath = '/api/Notification/Get';
  static const String shortcutsPath = '/api/Search/shortcuts';
  static const String latestMaterialsPath = '/api/Search/lastmaterials';
  static const String offersPath = '/api/Search/offers';
  static const String barcodeLookupApiKey =
      'dPBtpSjAqG2cAwwDbBBM35kPrMWd4PIEydwCXfUYRvWA4miJ';
  static const Map<String, String> barcodeImageHeaders = {
    'x-api-key': barcodeLookupApiKey,
  };

  /// Toggle between mock data sources and the real backend.
  /// Flip to `false` once the backend endpoints are available.
  static const bool useMockData = true;

  // Mock asset paths.
  static const String mockProducts = 'assets/mock/products.json';
  static const String mockNotifications = 'assets/mock/notifications.json';

  // SharedPreferences keys.
  static const String prefAuthToken = 'auth_token';
  static const String prefIsGuest = 'is_guest';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLocale = 'locale';
}
