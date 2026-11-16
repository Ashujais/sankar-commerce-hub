/// Application wide constants and configuration keys.
class AppConstants {
  AppConstants._();

  static const String appName = 'Sankar Commerce Hub';
  static const String companyName = 'Sankar Group';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Quality, Integrity & Industrial Excellence';

  // Local Storage (SharedPreferences) Keys
  static const String keyIsLoggedIn = 'sankar_is_logged_in';
  static const String keyUserSession = 'sankar_user_session';
  static const String keyRememberMe = 'sankar_remember_me';
  static const String keyThemeMode = 'sankar_theme_mode';
  static const String keyFavorites = 'sankar_favorites_list';
  static const String keyCartItems = 'sankar_cart_items';

  // Demo User Credentials for Quick Test
  static const String demoEmail = 'intern@sankargroup.com';
  static const String demoPassword = 'Password123!';
  static const String demoName = 'Sankar Trainee';
  static const String demoPhone = '+91 98765 43210';

  // Promo Code for Cart
  static const String validPromoCode = 'SANKAR10';
  static const double promoDiscountPercent = 0.10; // 10%
  static const double freeShippingThreshold = 50.0;
  static const double standardShippingFee = 9.99;
}
