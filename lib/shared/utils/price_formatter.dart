/// Currency formatting helper. Centralised so changing currency is one edit.
class PriceFormatter {
  PriceFormatter._();

  static String format(double value) {
    final raw = value.round().toString();
    final formatted = raw.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '$formatted IQD';
  }
}
