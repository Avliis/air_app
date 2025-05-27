import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((isAuth) {
      _isAuthenticated = isAuth;
      if (!isAuth) {
        _user = null;
      }
      notifyListeners();
    });

    // Listen to user changes
    _authService.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });

    // Check if user is already logged in
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      _isAuthenticated = isLoggedIn;
      
      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      
      _user = response.user;
      _isAuthenticated = true;
      return null; // Success
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado ao fazer login';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _setLoading(true);
    try {
      await _authService.register(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      return null; // Success
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado ao criar conta';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    _setLoading(true);
    try {
      _user = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
      
      return null; // Success
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado ao atualizar perfil';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      // Even if logout fails, clear local state
      _user = null;
      _isAuthenticated = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logoutAll() async {
    _setLoading(true);
    try {
      await _authService.logoutAll();
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      // Even if logout fails, clear local state
      _user = null;
      _isAuthenticated = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> deactivateAccount() async {
    _setLoading(true);
    try {
      await _authService.deactivateAccount();
      _user = null;
      _isAuthenticated = false;
      return null; // Success
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado ao desativar conta';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
