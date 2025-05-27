class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const String apiTimeout = '30'; // seconds
  
  // App Configuration
  static const String appName = 'Air App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  
  // Validation
  static const int passwordMinLength = 6;
  static const int usernameMinLength = 3;
  
  // Network
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
}
