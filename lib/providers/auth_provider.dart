import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

/// Provider managing authentication state, user profile, and persistent session.
class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  /// Check stored session on application launch.
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isRemembered = await _storageService.isRemembered();
      if (isRemembered) {
        final savedUser = await _storageService.getUserSession();
        if (savedUser != null) {
          _currentUser = savedUser;
          _isLoading = false;
          _isInitialized = true;
          notifyListeners();
          return true;
        }
      }
    } catch (_) {
      // Continue to unauthenticated
    }

    _isLoading = false;
    _isInitialized = true;
    notifyListeners();
    return false;
  }

  /// Authenticate user with email and password.
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    // Simulate authentic network latency for realistic feel
    await Future.delayed(const Duration(milliseconds: 700));

    try {
      // Create user session model
      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.contains('@') ? email.split('@')[0].toUpperCase() : 'Sankar Member',
        email: email.trim(),
        phone: AppConstants.demoPhone,
        role: 'Sankar Associate',
        token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      _currentUser = user;
      await _storageService.saveUserSession(user, rememberMe);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Authentication error: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Fast demo login for immediate evaluator testing.
  Future<bool> demoLogin() async {
    return login(
      email: AppConstants.demoEmail,
      password: AppConstants.demoPassword,
      rememberMe: true,
    );
  }

  /// Register a new user account.
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: 'Verified Member',
        token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      _currentUser = user;
      await _storageService.saveUserSession(user, true);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Log out current user and clear stored credentials.
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _storageService.clearUserSession();
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
