import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // Para capturar SocketException

class AuthService {
  final String apiUrl = 'https://reciclapp.net/api/reciclapp_api.php';

  // Método para registrar usuario
  Future<Map<String, dynamic>> register(String name, String phone, String email,
      String password, int rolId) async {
    try {
      String defaultPhoto = 'https://reciclapp.net/default/profile.png';

      // Enviar solicitud POST para registrar el usuario
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'register',
          'name': name,
          'photo': defaultPhoto,
          'phone': phone,
          'email': email,
          'password': password,
          'rol_id': rolId,
        }),
      );

      final data = json.decode(response.body);

      // Verificar si el registro fue exitoso
      if (response.statusCode == 200) {
        // Si el registro tiene algún error relacionado con el correo duplicado
        if (data['error'] != null &&
            data['error'] == 'El email ya está registrado.') {
          return {
            'error': 'El correo ya está registrado. Por favor, usa otro.'
          };
        }

        // Si el registro fue exitoso
        if (data['success'] == true) {
          final user = data['user'] ?? {};
          final String name = user['name'] ?? 'Usuario';
          final String photo = user['photo'] ?? defaultPhoto;

          // Guardar en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', name);
          await prefs.setString('photo', photo);
          await prefs.setInt('rol_id', rolId);
          await prefs.setString('token', data['token'] ?? '');

          return {
            'success': true,
            'token': data['token'] ?? '',
            'user': {
              'name': name,
              'photo': photo,
              'rol_id': rolId,
            },
          };
        } else {
          return {'error': data['error'] ?? 'Error en el registro.'};
        }
      } else if (response.statusCode == 409) {
        // Manejar el error de conflicto (email ya registrado)
        return {'error': 'El correo ya está registrado. Por favor, usa otro.'};
      } else {
        // Manejar otros códigos de error
        return {
          'error': 'Error en el servidor. Código: ${response.statusCode}'
        };
      }
    } on SocketException {
      // Captura la excepción de falta de conexión
      return {'error': 'No tienes conexión a Internet.'};
    } catch (e) {
      // Manejar cualquier excepción durante la solicitud
      return {'error': 'Error en la solicitud: $e'};
    }
  }

  // Método para iniciar sesión
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'login',
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificar si la API devuelve éxito
        if (data['success'] == true) {
          final user = data['user'] ?? {};
          final String name = user['name'] ?? 'Usuario';
          final String photo = user['photo'] ?? '';
          final int rolId = user['rol_id'] ?? 1;

          // Almacenar los datos del usuario en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', name);
          await prefs.setString('photo', photo);
          await prefs.setInt('rol_id', rolId);
          await prefs.setString('token', data['token']);

          return {
            'success': true,
            'token': data['token'],
            'user': {
              'name': name,
              'photo': photo,
              'rol_id': rolId,
            },
          };
        } else {
          return {'error': data['error'] ?? 'Credenciales incorrectas.'};
        }
      } else if (response.statusCode == 401) {
        return {'error': 'Usuario o contraseña incorrectos.'};
      } else {
        return {
          'error': 'Error en el servidor. Código: ${response.statusCode}'
        };
      }
    } on SocketException {
      // Captura la excepción de falta de conexión
      return {'error': 'No tienes conexión a Internet.'};
    } catch (e) {
      return {'error': 'Error en la solicitud: $e'};
    }
  }

  // Método para obtener el rol guardado en SharedPreferences
  Future<int?> getStoredRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('rol_id'); // Devuelve null si no existe
  }

  // Método para verificar y redirigir según el rol al iniciar la app
  Future<void> checkUserRole(BuildContext context) async {
    final int? rolId = await getStoredRole();

    if (rolId != null) {
      if (rolId == 2) {
        // Recolector
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/homecollector');
      } else if (rolId == 3) {
        // Usuario estándar
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Otros roles o sin rol, llevar a login
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Si no hay rol guardado, redirigir a login
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Método para verificar si el usuario está logueado
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  Future<bool> hasRole(int requiredRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? rolId = prefs.getInt('rol_id');
    return rolId == requiredRole;
  }

  // Método para obtener los datos del usuario guardados en SharedPreferences
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('name');
    final String? photo = prefs.getString('photo');
    final int? rolId = prefs.getInt('rol_id');
    final String? token = prefs.getString('token');
    return {
      'name': name,
      'photo': photo,
      'rol_id': rolId,
      'token': token,
    };
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('photo');
    await prefs.remove('rol_id');
    await prefs.remove('token');
  }
}
