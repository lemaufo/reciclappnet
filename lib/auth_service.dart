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
          await prefs.setString('phone',
              phone); // PROBAR Si funciona para mostrar en updateProfile()
          await prefs.setInt('rol_id', rolId);
          await prefs.setString('token', data['token'] ?? '');

          return {
            'success': true,
            'token': data['token'] ?? '',
            'user': {
              'name': name,
              'photo': photo,
              'password':
                  password, // PROBAR Si funciona para mostrar en updateProfile()
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

  // Método para actualizar el perfil del usuario
  Future<Map<String, dynamic>> updateProfile(
      String name, String phone, String? password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        return {
          'error': 'No se ha encontrado el ID de usuario en la sesión actual.'
        };
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'action': 'update_profile',
          'id': userId, // Usar el ID de usuario almacenado
          'name': name,
          'phone': phone,
          'password': password, // Puede ser null si no se cambia
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {'success': true, 'message': data['message']};
        } else {
          return {'error': data['error'] ?? 'Error al actualizar el perfil.'};
        }
      } else {
        return {
          'error': 'Error en el servidor. Código: ${response.statusCode}'
        };
      }
    } on SocketException {
      return {'error': 'No tienes conexión a Internet.'};
    } catch (e) {
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
          final int userId =
              user['id']; // PRUEBA PARA VER SI ALMACENAR EL ID CORRECTO
          final String name = user['name'] ?? 'Usuario';
          final String photo = user['photo'] ?? '';
          final String phone = user['phone'] ??
              ''; //Probar si fucniona para mostrar en updateProfile()
          final String password = user['password'] ??
              ''; //Probar si funciona para mostrar en updateProfile()
          final int rolId = user['rol_id'] ?? 1;

          // Almacenar los datos del usuario en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id',
              userId); // PRUEBA PARA VER SI Almacena el ID del usuario
          await prefs.setString('name', name);
          await prefs.setString('photo', photo);
          await prefs.setString('phone',
              phone); //Probar si funciona para mostrar en updateProfile()
          await prefs.setInt('rol_id', rolId);
          await prefs.setString('token', data['token']);

          return {
            'success': true,
            'token': data['token'],
            'user': {
              'name': name,
              'photo': photo,
              'phone':
                  phone, //Probar si funciona para mostrar en updateProfile()
              'password':
                  password, //Probar si funciona para mostrar en updateProfile()
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
    final String? phone = prefs.getString('phone');
    final int? rolId = prefs.getInt('rol_id');
    final String? token = prefs.getString('token');
    return {
      'name': name,
      'photo': photo,
      'phone': phone, //Probar si funciona para mostrar en updateProfile()
      'rol_id': rolId,
      'token': token,
    };
  }

  // Método para obtener categorias de materiales
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"action": "get_material_categories"}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        List<dynamic> data = responseData['material_categories'];
        return data
            .map((item) => {
                  'name': item['name'],
                  'description': item[
                      'description'] // Ajustado para coincidir con la respuesta esperada
                })
            .toList();
      } else {
        throw Exception('Error en la respuesta de la API');
      }
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  // Método para obtener Solicitudes
  Future<List<Map<String, dynamic>>> fetchRequests(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "action": "get_requests",
          "user_id": userId,
        }),
      );

      // Imprime el cuerpo de la respuesta para depuración
      // ignore: avoid_print
      print('Respuesta de la API: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          List<dynamic> data = responseData['requests'];
          return data.map((item) {
            return {
              'code': item['code'],
              'status': item['status'],
              'created_at': item['created_at'],
              'hour': item['hour'],
              'scheduled_date': item['scheduled_date'],
            };
          }).toList();
        } else {
          throw Exception(
              'Error en la respuesta de la API: ${responseData['message'] ?? 'Sin mensaje de error'}');
        }
      } else {
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Excepción al obtener solicitudes: $e');
      throw Exception('Error al cargar solicitudes');
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('photo');
    await prefs
        .remove('phone'); //Probar si funciona para mostrar en updateProfile()
    await prefs.remove(
        'password'); //Probar si funciona para mostrar en updateProfile()
    await prefs.remove('rol_id');
    await prefs.remove('token');
  }
}
