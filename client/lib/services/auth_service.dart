import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // URL de base de l'API (à ajuster selon votre configuration)
  static const String _baseUrl = 'http://localhost:8000/api';
  
  // Clés pour le stockage local
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  
  // En-têtes HTTP communs
  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };
  
  // Inscription d'un nouvel utilisateur
  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData,
          'message': 'Inscription réussie',
        };
      } else {
        return {
          'success': false,
          'message': responseData['detail'] ?? 'Erreur lors de l\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur: ${e.toString()}',
      };
    }
  }
  
  // Connexion d'un utilisateur
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // L'API FastAPI attend username/password pour OAuth2
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': email, // FastAPI utilise 'username' même pour les emails
          'password': password,
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Stocker le token JWT
        final token = responseData['access_token'];
        await _saveAuthData(token, email);
        
        // Récupérer les informations de l'utilisateur
        final userInfo = await getUserInfo(token);
        
        if (userInfo['success']) {
          // Stocker le nom d'utilisateur
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userNameKey, userInfo['data']['username']);
          
          return {
            'success': true,
            'token': token,
            'user': userInfo['data'],
            'message': 'Connexion réussie',
          };
        } else {
          return {
            'success': true,
            'token': token,
            'message': 'Connexion réussie, mais impossible de récupérer les informations utilisateur',
          };
        }
      } else {
        return {
          'success': false,
          'message': responseData['detail'] ?? 'Identifiants incorrects',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur: ${e.toString()}',
      };
    }
  }
  
  // Récupérer les informations de l'utilisateur connecté
  static Future<Map<String, dynamic>> getUserInfo([String? token]) async {
    try {
      final authToken = token ?? await getToken();
      
      if (authToken == null) {
        return {
          'success': false,
          'message': 'Non authentifié',
        };
      }
      
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['detail'] ?? 'Erreur lors de la récupération des informations utilisateur',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur: ${e.toString()}',
      };
    }
  }
  
  // Déconnexion (suppression du token)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }
  
  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
  
  // Récupérer le token JWT
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Récupérer l'email de l'utilisateur connecté
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }
  
  // Récupérer le nom d'utilisateur
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }
  
  // Sauvegarder les données d'authentification
  static Future<void> _saveAuthData(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userEmailKey, email);
  }
}
