class CardValidator {
  // Format card number with spaces every 4 digits
  static String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  // Format expiry date as MM/YY
  static String formatExpiry(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  // Validate card number using Luhn algorithm
  static bool validateCardNumber(String value) {
    value = value.replaceAll(' ', '');
    if (value.length != 16) return false;

    // Luhn algorithm
    int sum = 0;
    bool isSecond = false;
    for (int i = value.length - 1; i >= 0; i--) {
      int digit = int.parse(value[i]);
      if (isSecond) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isSecond = !isSecond;
    }
    return sum % 10 == 0;
  }

  // Validate expiry date
  static bool validateExpiry(String value) {
    if (!value.contains('/')) return false;
    final parts = value.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;

    return true;
  }
}