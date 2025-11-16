class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'My Flutter App';
  static const String appVersion = '1.0.0';

  // API URLs
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);

  // Pagination
  static const int pageSize = 20;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;

// Add more constants as needed
}