class CurrencyHelper {
  CurrencyHelper._();

  static String format(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}
