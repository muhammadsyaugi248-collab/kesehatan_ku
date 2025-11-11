/// Helper untuk memformat harga dengan pemisah ribuan (titik) untuk mata uang IDR.
///
/// Contoh: 150000.0 -> "150.000"
String formatPrice(double price) {
  final int value = price.round();
  String priceStr = value.toString();
  String result = '';

  // Looping dari belakang untuk menambahkan titik setiap 3 digit
  for (int i = priceStr.length - 1, count = 0; i >= 0; i--, count++) {
    result = priceStr[i] + result;
    if (count % 3 == 2 && i != 0) {
      result = '.' + result;
    }
  }
  return result;
}
