import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/cart_item_model.dart';

/// Central local persistence service wrapping SharedPreferences.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ---------------- AUTH PERSISTENCE ---------------- //

  Future<void> saveUserSession(UserModel user, bool rememberMe) async {
    final p = await prefs;
    await p.setBool(AppConstants.keyIsLoggedIn, true);
    await p.setBool(AppConstants.keyRememberMe, rememberMe);
    await p.setString(AppConstants.keyUserSession, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUserSession() async {
    final p = await prefs;
    final isLoggedIn = p.getBool(AppConstants.keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final userJsonStr = p.getString(AppConstants.keyUserSession);
    if (userJsonStr == null || userJsonStr.isEmpty) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(userJsonStr);
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isRemembered() async {
    final p = await prefs;
    return p.getBool(AppConstants.keyRememberMe) ?? false;
  }

  Future<void> clearUserSession() async {
    final p = await prefs;
    await p.remove(AppConstants.keyIsLoggedIn);
    await p.remove(AppConstants.keyUserSession);
    await p.remove(AppConstants.keyRememberMe);
  }

  // ---------------- THEME PERSISTENCE ---------------- //

  Future<void> saveThemeMode(String mode) async {
    final p = await prefs;
    await p.setString(AppConstants.keyThemeMode, mode);
  }

  Future<String?> getThemeMode() async {
    final p = await prefs;
    return p.getString(AppConstants.keyThemeMode);
  }

  // ---------------- FAVORITES PERSISTENCE ---------------- //

  Future<void> saveFavorites(List<String> favoriteIds) async {
    final p = await prefs;
    await p.setStringList(AppConstants.keyFavorites, favoriteIds);
  }

  Future<List<String>> getFavorites() async {
    final p = await prefs;
    return p.getStringList(AppConstants.keyFavorites) ?? [];
  }

  // ---------------- CART PERSISTENCE ---------------- //

  Future<void> saveCartItems(List<CartItemModel> items) async {
    final p = await prefs;
    final list = items.map((i) => i.toJson()).toList();
    await p.setString(AppConstants.keyCartItems, jsonEncode(list));
  }

  Future<List<CartItemModel>> getCartItems() async {
    final p = await prefs;
    final jsonStr = p.getString(AppConstants.keyCartItems);
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------- RESET ALL ---------------- //

  Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }
}
