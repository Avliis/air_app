import 'dart:async';
import '../models/user.dart';
import '../models/auth_response.dart';
import 'api_service.dart';
import 'secure_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();

  // Stream para notificar mudanças no estado de autenticação
  final _authStateController = StreamController<bool>.broadcast();
  Stream<bool> get authStateChanges => _authStateController.stream;

  // Current user stream
  final _userController = StreamController<User?>.broadcast();
  Stream<User?> get userChanges => _userController.stream;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
    );
    
    final response = await _apiService.login(request);
    
    // Save tokens and user info
    await _storageService.saveAccessToken(response.accessToken);
    await _storageService.saveRefreshToken(response.refreshToken);
    await _storageService.saveUserId(response.user.id);
    await _storageService.saveUserEmail(response.user.email);
    
    _currentUser = response.user;
    _notifyAuthStateChanged(true);
    _userController.add(_currentUser);
    
    return response;
  }

  Future<User> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final request = RegisterRequest(
      email: email,
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    
    final user = await _apiService.register(request);
    return user;
  }

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final token = await _storageService.getAccessToken();
    if (token == null) return null;

    try {
      _currentUser = await _apiService.getProfile(token);
      _userController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      // Token might be invalid, try to refresh
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        return getCurrentUser();
      }
      return null;
    }
  }

  Future<User> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    final token = await _getValidToken();
    if (token == null) {
      throw ApiException('Não autenticado', 401);
    }

    final request = UpdateProfileRequest(
      firstName: firstName,
      lastName: lastName,
    );
    
    _currentUser = await _apiService.updateProfile(token, request);
    _userController.add(_currentUser);
    
    return _currentUser!;
  }

  Future<void> logout() async {
    final token = await _storageService.getAccessToken();
    final refreshToken = await _storageService.getRefreshToken();
    
    if (token != null) {
      try {
        await _apiService.logout(token, refreshToken);
      } catch (e) {
        // Continue with logout even if API call fails
      }
    }
    
    await _storageService.clearAll();
    _currentUser = null;
    _notifyAuthStateChanged(false);
    _userController.add(null);
  }

  Future<void> logoutAll() async {
    final token = await _getValidToken();
    if (token == null) {
      throw ApiException('Não autenticado', 401);
    }
    
    try {
      await _apiService.logoutAll(token);
    } catch (e) {
      // Continue with logout even if API call fails
    }
    
    await _storageService.clearAll();
    _currentUser = null;
    _notifyAuthStateChanged(false);
    _userController.add(null);
  }

  Future<void> deactivateAccount() async {
    final token = await _getValidToken();
    if (token == null) {
      throw ApiException('Não autenticado', 401);
    }
    
    await _apiService.deactivateAccount(token);
    
    // Clear local data after deactivation
    await _storageService.clearAll();
    _currentUser = null;
    _notifyAuthStateChanged(false);
    _userController.add(null);
  }

  Future<bool> isLoggedIn() async {
    final isStored = await _storageService.isLoggedIn();
    if (!isStored) return false;

    // Verify token is still valid
    final token = await _storageService.getAccessToken();
    if (token == null) return false;

    final isValid = await _apiService.verifyToken(token);
    if (isValid) return true;

    // Try to refresh token
    final refreshed = await _tryRefreshToken();
    return refreshed;
  }

  Future<String?> _getValidToken() async {
    String? token = await _storageService.getAccessToken();
    if (token == null) return null;

    // Check if token is valid
    final isValid = await _apiService.verifyToken(token);
    if (isValid) return token;

    // Try to refresh
    final refreshed = await _tryRefreshToken();
    if (refreshed) {
      return await _storageService.getAccessToken();
    }

    return null;
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiService.refreshToken(refreshToken);
      
      // Update stored tokens
      await _storageService.saveAccessToken(response.accessToken);
      await _storageService.saveRefreshToken(response.refreshToken);
      
      _currentUser = response.user;
      _userController.add(_currentUser);
      
      return true;
    } catch (e) {
      // Refresh failed, clear everything
      await _storageService.clearAll();
      _currentUser = null;
      _notifyAuthStateChanged(false);
      _userController.add(null);
      return false;
    }
  }

  void _notifyAuthStateChanged(bool isAuthenticated) {
    _authStateController.add(isAuthenticated);
  }

  void dispose() {
    _authStateController.close();
    _userController.close();
  }
}
