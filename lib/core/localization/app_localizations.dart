import 'package:flutter/widgets.dart';

/// Lightweight localization without codegen. Supports English + Arabic.
/// For larger apps switch to flutter gen-l10n; the lookup API stays the same.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  bool get isRtl => locale.languageCode == 'ar';

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'app_name': 'سانكو مول',
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'continue_guest': 'Continue as guest',
      'scanner': 'Scanner',
      'cart': 'Cart',
      'notifications': 'Notifications',
      'add_to_cart': 'Add to cart',
      'cart_item_added': 'Item added to cart',
      'cart_product_added': '{product} added to cart',
      'price': 'Price',
      'single': 'Single',
      'carton': 'Carton',
      'quantity': 'Quantity',
      'total': 'Total',
      'clear_cart': 'Clear cart',
      'cart_empty': 'Your cart is empty',
      'scan_hint': 'Point the camera at a barcode',
      'add_manually': 'Add manually',
      'shortcuts': '+ Shortcuts',
      'no_notifications': 'No notifications yet',
      'remove': 'Remove',
      'product_not_found': 'Product not found',
      'logout': 'Logout',
      'checkout': 'Checkout',
      'home': 'Home',
      'search': 'Search',
      'account': 'Account',
      'offers': 'Offers',
      'weekly_offers': 'Weekend Offers',
      'scan_product': 'Scan Product',
      'welcome_back': 'Welcome back',
      'cart_total': 'Cart total',
      'latest_products': 'Latest products',
      'quick_shortcuts': 'Quick shortcuts',
      'view_all': 'View all',
      'start_now': 'Start now',
      'instruction_title_1': 'Scan the barcode',
      'instruction_body_1': 'Bring your camera close to any product barcode.',
      'instruction_title_2': 'Track your basket',
      'instruction_body_2': 'Follow basket total while shopping in real time.',
      'instruction_title_3': 'Use offers wisely',
      'instruction_body_3': 'Apply active offers to save more on every visit.',
      'start_scanning': 'Start scanning',
      'stop_scanning': 'Stop scanning',
      'basket_summary': 'Basket summary',
      'items_count': 'Items count',
      'continue_shopping': 'Continue shopping',
      'empty_search': 'Type to search products',
      'special_offers': 'Special offers',
      'selected_products': 'Selected products',
      'last_scanned': 'Last scanned product',
      'barcode': 'Barcode',
      'skip': 'Skip',
      'profile_hint': 'Your rewards and account details will appear here.',
      'all': 'All',
    },
    'ar': {
      'app_name': 'سانكو مول',
      'login': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'continue_guest': 'المتابعة كزائر',
      'scanner': 'الماسح',
      'cart': 'السلة',
      'notifications': 'الإشعارات',
      'add_to_cart': 'أضف إلى السلة',
      'cart_item_added': 'تمت إضافة المادة إلى السلة',
      'cart_product_added': 'تمت إضافة {product} إلى السلة',
      'price': 'السعر',
      'single': 'مفرد',
      'carton': 'كرتون',
      'quantity': 'الكمية',
      'total': 'الإجمالي',
      'clear_cart': 'إفراغ السلة',
      'cart_empty': 'سلتك فارغة',
      'scan_hint': 'وجّه الكاميرا نحو الباركود',
      'add_manually': 'إضافة يدويًا',
      'shortcuts': '+ المختصرات',
      'no_notifications': 'لا توجد إشعارات بعد',
      'remove': 'إزالة',
      'product_not_found': 'المنتج غير متوفر',
      'logout': 'تسجيل الخروج',
      'checkout': 'الدفع',
      'home': 'الرئيسية',
      'search': 'بحث',
      'account': 'حسابي',
      'offers': 'العروض',
      'weekly_offers': 'عروض نهاية الأسبوع',
      'scan_product': 'مسح منتج',
      'welcome_back': 'مرحباً بعودتك',
      'cart_total': 'إجمالي السلة',
      'latest_products': 'آخر المنتجات',
      'quick_shortcuts': 'اختصارات سريعة',
      'view_all': 'عرض الكل',
      'start_now': 'ابدأ الآن',
      'instruction_title_1': 'امسح الباركود',
      'instruction_body_1': 'وجّه الكاميرا نحو باركود أي منتج لإضافته فوراً.',
      'instruction_title_2': 'تابع سلتك بنفسك',
      'instruction_body_2': 'شاهد إجمالي مشترياتك لحظة بلحظة أثناء التسوق.',
      'instruction_title_3': 'استفد من العروض',
      'instruction_body_3': 'فعّل العروض المتاحة لتحصل على أفضل سعر.',
      'start_scanning': 'ابدأ المسح',
      'stop_scanning': 'إيقاف المسح',
      'basket_summary': 'ملخص السلة',
      'items_count': 'عدد المواد',
      'continue_shopping': 'متابعة التسوق',
      'empty_search': 'اكتب للبحث عن منتج',
      'special_offers': 'العروض الخاصة',
      'selected_products': 'المنتجات المختارة',
      'last_scanned': 'آخر منتج تم مسحه',
      'barcode': 'الباركود',
      'skip': 'تخطي',
      'profile_hint': 'ستظهر هنا بيانات الحساب ونقاط الولاء قريباً.',
      'all': 'الكل',
    },
  };

  String t(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
