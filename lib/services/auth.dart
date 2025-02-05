// services/api_services.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenverse_mobile_apps/model/admin_model.dart';

class ApiAuthService {
  static const String baseUrl = 'https://zenversegames-ba223a40f69e.herokuapp.com';
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

 
  static Future<bool> isTokenAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

 
  static Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: jsonEncode({
          'user_name': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);


        bool tokenExists = await isTokenAvailable();
        print('Token available after login: $isTokenAvailable');
        if (tokenExists) {
          print('Token successfully stored.');
          return true; 
        } else {
          print('Failed to store token.');
          return false; 
        }
      } else {
        return false; 
      }
    } on DioException catch (e) {
      print('Login Error: ${e.response?.data ?? e.message}');
      return false;
    }
  }

 
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return false;

    try {
      final response = await _dio.post(
        '/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        await prefs.remove('token'); 
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print('Logout Error: ${e.response?.data ?? e.message}');
      return false;
    }
  }


  static Future<Admin?> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await _dio.get(
        '/dashboard',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return Admin.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Dashboard Error: ${e.response?.data ?? e.message}');
      return null;
    }
  }
}
