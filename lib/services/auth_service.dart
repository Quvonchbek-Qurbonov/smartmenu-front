import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://167.172.122.176:8000/api';

  // Configure secure storage with Android options
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Storage keys
  static const String _tokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userGenderKey = 'user_gender';
  static const String _userAgeKey = 'user_age';
  static const String _isVerifiedKey = 'is_verified';

  // Helper method to check if status code is successful
  static bool _isSuccessStatusCode(int statusCode) {
    return statusCode == 200 || statusCode == 201 || statusCode == 204;
  }

  // ============ TOKEN MANAGEMENT ============

  static Future<void> saveToken(String token) async {
    debugPrint('Saving token: ${token.substring(0, 30)}...');
    await _storage.write(key: _tokenKey, value: token);

    // Verify it was saved
    final saved = await _storage.read(key: _tokenKey);
    debugPrint('Token saved successfully: ${saved != null}');
  }

  static Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    debugPrint('Getting token: ${token != null ? "${token.substring(0, 30)}...  " : "null"}');
    return token;
  }

  static Future<void> deleteToken() async {
    await _storage. delete(key: _tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    final result = token != null && token.isNotEmpty;
    debugPrint('isLoggedIn check: $result (token: ${token != null ? "exists" : "null"})');
    return result;
  }

  // Debug method to show storage contents
  static Future<void> debugStorageContents() async {
    debugPrint('╔════════════════════════════════════╗');
    debugPrint('║      SECURE STORAGE CONTENTS       ║');
    debugPrint('╠════════════════════════════════════╣');
    final token = await _storage.read(key: _tokenKey);
    debugPrint('║ Token: ${token != null ? "${token. substring(0, 20)}..." : "NULL"}');
    debugPrint('║ User ID: ${await _storage. read(key: _userIdKey)}');
    debugPrint('║ Email: ${await _storage.read(key: _userEmailKey)}');
    debugPrint('║ Name: ${await _storage.read(key: _userNameKey)}');
    debugPrint('║ Gender: ${await _storage.read(key: _userGenderKey)}');
    debugPrint('║ Age: ${await _storage.read(key: _userAgeKey)}');
    debugPrint('║ Verified: ${await _storage.read(key: _isVerifiedKey)}');
    debugPrint('╚════════════════════════════════════╝');
  }

  // ============ USER DATA MANAGEMENT ============

  static Future<void> saveUserData({
    required String id,
    required String email,
    String? fullName,
    String? gender,
    int? age,
    bool? isVerified,
  }) async {
    debugPrint('Saving user data: id=$id, email=$email');
    await _storage.write(key: _userIdKey, value: id);
    await _storage. write(key: _userEmailKey, value: email);
    if (fullName != null) {
      await _storage.write(key: _userNameKey, value: fullName);
    }
    if (gender != null) {
      await _storage.write(key: _userGenderKey, value: gender);
    }
    if (age != null) {
      await _storage.write(key: _userAgeKey, value: age. toString());
    }
    if (isVerified != null) {
      await _storage.write(key: _isVerifiedKey, value: isVerified. toString());
    }
    debugPrint('User data saved successfully');
  }

  static Future<Map<String, String?>> getUserData() async {
    return {
      'id': await _storage.read(key: _userIdKey),
      'email': await _storage.read(key: _userEmailKey),
      'full_name': await _storage.read(key: _userNameKey),
      'gender': await _storage.read(key: _userGenderKey),
      'age': await _storage.read(key: _userAgeKey),
      'is_verified': await _storage.read(key: _isVerifiedKey),
    };
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<void> clearUserData() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userNameKey);
    await _storage. delete(key: _userGenderKey);
    await _storage. delete(key: _userAgeKey);
    await _storage. delete(key: _isVerifiedKey);
  }

  // ============ AUTH API CALLS ============

  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String gender,
    required int age,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('=== REGISTER USER REQUEST ===');

      final body = {
        'full_name': fullName,
        'gender': gender. toLowerCase(),
        'age': age,
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (_isSuccessStatusCode(response. statusCode) && responseData['id'] != null) {
        await saveUserData(
          id: responseData['id'].toString(),
          email: responseData['email'] ?? email,
          fullName: responseData['full_name'] ?? fullName,
          gender: responseData['gender'] ?? gender,
          age: responseData['age'] ??  age,
          isVerified: responseData['is_verified'] ??  false,
        );

        debugPrint('✓ Registration successful!  User ID: ${responseData['id']}');

        return {
          'success': true,
          'message': 'Registration successful.  Please verify your account.',
          'user_id': responseData['id'],
          'data': responseData,
        };
      }

      return {
        'success': false,
        'message': _parseErrorMessage(responseData, 'Registration failed'),
      };
    } catch (e) {
      debugPrint('Registration error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  /// Verify OTP after registration
  static Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    try {
      debugPrint('=== VERIFY OTP REQUEST ===');

      final body = {
        'user_id': userId,
        'otp': otp,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (_isSuccessStatusCode(response.statusCode) && responseData['id'] != null) {
        await saveUserData(
          id: responseData['id'].toString(),
          email: responseData['email'],
          fullName: responseData['full_name'],
          gender: responseData['gender'],
          age: responseData['age'],
          isVerified: responseData['is_verified'] ?? true,
        );

        debugPrint('✓ OTP verification successful!');

        return {
          'success': true,
          'message': 'Account verified successfully',
          'data': responseData,
        };
      }

      return {
        'success': false,
        'message': _parseErrorMessage(responseData, 'Verification failed'),
      };
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  /// Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('=== LOGIN REQUEST ===');

      final body = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json. encode(body),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      final responseData = json.decode(response. body);

      if (_isSuccessStatusCode(response.statusCode) && responseData['access_token'] != null) {
        // Save access token
        await saveToken(responseData['access_token']);

        // Save user data
        final userData = responseData['data'];
        if (userData != null) {
          await saveUserData(
            id: userData['id'].toString(),
            email: userData['email'] ?? email,
            fullName: userData['full_name'],
            gender: userData['gender'],
            age: userData['age'],
            isVerified: userData['is_verified'],
          );
        }

        debugPrint('✓ Login successful! Token saved.');

        // Debug: Verify storage
        await debugStorageContents();

        return {
          'success': true,
          'message': 'Login successful',
          'data': userData,
          'access_token': responseData['access_token'],
        };
      }

      return {
        'success': false,
        'message': _parseErrorMessage(responseData, 'Login failed'),
      };
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  /// Helper to parse error message
  static String _parseErrorMessage(Map<String, dynamic> data, String defaultMessage) {
    if (data['detail'] != null) {
      if (data['detail'] is String) {
        return data['detail'];
      } else if (data['detail'] is List && data['detail'].isNotEmpty) {
        return data['detail'][0]['msg'] ?? defaultMessage;
      }
    } else if (data['message'] != null) {
      return data['message'];
    }
    return defaultMessage;
  }

  /// Verify if token is still valid
  static Future<bool> verifyToken() async {
    try {
      final token = await getToken();
      if (token == null) {
        debugPrint('verifyToken: No token found');
        return false;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('verifyToken status: ${response.statusCode}');

      if (_isSuccessStatusCode(response. statusCode)) {
        final responseData = json.decode(response. body);
        final userData = responseData['data'] ?? responseData;

        if (userData != null && userData['id'] != null) {
          await saveUserData(
            id: userData['id'].toString(),
            email: userData['email'],
            fullName: userData['full_name'],
            gender: userData['gender'],
            age: userData['age'],
            isVerified: userData['is_verified'],
          );
        }
        debugPrint('verifyToken: Token is valid');
        return true;
      }
      debugPrint('verifyToken: Token is invalid');
      return false;
    } catch (e) {
      debugPrint('Token verification error: $e');
      return false;
    }
  }

  /// Logout user
  static Future<void> logout() async {
    debugPrint('Logging out - clearing all data');
    await deleteToken();
    await clearUserData();
  }

  // ============ AUTHENTICATED API REQUESTS ============

  static Future<http.Response> authenticatedGet(String endpoint) async {
    final token = await getToken();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> authenticatedPost(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final token = await getToken();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? json.encode(body) : null,
    );
  }

  static Future<http. Response> authenticatedPut(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final token = await getToken();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ?  json.encode(body) : null,
    );
  }

  static Future<http.Response> authenticatedDelete(String endpoint) async {
    final token = await getToken();
    return http.delete(
      Uri. parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}