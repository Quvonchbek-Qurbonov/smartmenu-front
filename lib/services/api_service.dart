import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL
  final String _baseUrl = AppConstants.baseUrl;

  // Headers
  Map<String, String> _getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET Request
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? queryParams,
        String? token,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint').replace(
        queryParameters: queryParams,
      );

      if (kDebugMode) {
        print('GET Request: $uri');
      }

      // Note: In a real app, use http package or dio
      // Example with http package:
      // final response = await http.get(uri, headers: _getHeaders(token: token));
      // return jsonDecode(response.body);

      // For demo purposes, returning mock data
      return {
        'success': true,
        'message': 'GET request successful',
        'data': {},
      };
    } catch (e) {
      if (kDebugMode) {
        print('GET Error: $e');
      }
      rethrow;
    }
  }

  // POST Request
  Future<Map<String, dynamic>> post(
      String endpoint, {
        required Map<String, dynamic> body,
        String? token,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');

      if (kDebugMode) {
        print('POST Request: $uri');
        print('Body: ${jsonEncode(body)}');
      }

      // Note: In a real app, use http package or dio
      // Example with http package:
      // final response = await http.post(
      //   uri,
      //   headers: _getHeaders(token: token),
      //   body: jsonEncode(body),
      // );
      // return jsonDecode(response.body);

      // For demo purposes, returning mock data
      return {
        'success': true,
        'message': 'POST request successful',
        'data': body,
      };
    } catch (e) {
      if (kDebugMode) {
        print('POST Error: $e');
      }
      rethrow;
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> put(
      String endpoint, {
        required Map<String, dynamic> body,
        String? token,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');

      if (kDebugMode) {
        print('PUT Request: $uri');
        print('Body: ${jsonEncode(body)}');
      }

      // Note: In a real app, use http package or dio
      // For demo purposes, returning mock data
      return {
        'success': true,
        'message': 'PUT request successful',
        'data': body,
      };
    } catch (e) {
      if (kDebugMode) {
        print('PUT Error: $e');
      }
      rethrow;
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        String? token,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$endpoint');

      if (kDebugMode) {
        print('DELETE Request: $uri');
      }

      // Note: In a real app, use http package or dio
      // For demo purposes, returning mock data
      return {
        'success': true,
        'message': 'DELETE request successful',
      };
    } catch (e) {
      if (kDebugMode) {
        print('DELETE Error: $e');
      }
      rethrow;
    }
  }

  // Handle API Errors
  String handleError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'No internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout';
    } else {
      return 'Something went wrong';
    }
  }
}

// Usage Example:
// final apiService = ApiService();
// final response = await apiService.get('users', token: 'your_token');
// final response = await apiService.post('users', body: {'name': 'John'});