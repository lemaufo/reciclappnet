import 'package:flutter/material.dart';
import 'package:reciclapp/auth_service.dart'; // Importa tu servicio de autenticación
import 'package:reciclapp/custom_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // Fondo transparente
        elevation: 0, // Sin sombra

        toolbarHeight: 78.0,
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Contenedor con la lista de opciones
          Container(
            padding: const EdgeInsets.all(16.0),
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                // Elemento 1: Información personal
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/edit_profile');
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF104B28), // Fondo verde
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25, // Tamaño del ícono
                    ),
                  ),
                  title: const Text('Información personal',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const SizedBox(height: 15.0),
                // Elemento 2: Aviso de privacidad
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/profileprivacyandterms');
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF104B28), // Fondo verde
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  title: const Text('Aviso de privacidad',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const SizedBox(height: 15.0),
                // Elemento 3: Ayuda
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/help');
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF104B28), // Fondo verde
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  title: const Text('Ayuda',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const SizedBox(height: 15.0),
                // Elemento 4: Cerrar sesión
                ListTile(
                  onTap: () async {
                    // Llamamos al método logout de AuthService
                    await AuthService().logout();

                    // Redirigir al usuario a la pantalla de login después de cerrar sesión
                    Navigator.pushNamedAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      '/login',
                      (Route<dynamic> route) =>
                          false, // Elimina todas las rutas anteriores
                    );
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF104B28), // Fondo verde
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  title: const Text('Cerrar sesión',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
          // Botón Cerrar sesión
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       // Llamamos al método logout de AuthService
          //       await AuthService().logout();

          //       // Redirigir al usuario a la pantalla de login después de cerrar sesión
          //       Navigator.pushNamedAndRemoveUntil(
          //         // ignore: use_build_context_synchronously
          //         context,
          //         '/login',
          //         (Route<dynamic> route) =>
          //             false, // Elimina todas las rutas anteriores
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(
          //           0xFF104B28), // Cambia el color del botón si lo deseas
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          //     ),
          //     child: const Text(
          //       'Cerrar Sesión',
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }
}
