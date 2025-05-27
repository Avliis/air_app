import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/user.dart';
import '../config/app_config.dart';

class ApiService {
  static const String baseUrl = AppConfig.apiBaseUrl;
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['error'] ?? 'Erro ao fazer login',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<User> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(json['user']);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['error'] ?? 'Erro ao criar conta',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<User> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(json['user']);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['error'] ?? 'Erro ao obter perfil',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<User> updateProfile(String token, UpdateProfileRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: _getHeaders(token: token),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(json['user']);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['error'] ?? 'Erro ao atualizar perfil',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<void> logout(String token, String? refreshToken) async {
    try {
      final body = refreshToken != null ? {'refreshToken': refreshToken} : null;
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _getHeaders(token: token),
        body: body != null ? jsonEncode(body) : null,
      );
    } catch (e) {
      // Silently fail logout - token will be removed locally anyway
    }
  }

  Future<void> logoutAll(String token) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout-all'),
        headers: _getHeaders(token: token),
      );
    } catch (e) {
      // Silently fail logout - token will be removed locally anyway
    }
  }

  Future<void> deactivateAccount(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/deactivate'),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw ApiException(
          error['error'] ?? 'Erro ao desativar conta',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh-token'),
        headers: _getHeaders(),
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(json);
      } else {
        throw ApiException('Token expirado', 401);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão', 500);
    }
  }

  Future<bool> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify-token'),
        headers: _getHeaders(token: token),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
