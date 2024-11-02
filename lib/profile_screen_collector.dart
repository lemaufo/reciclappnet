import 'package:flutter/material.dart';
import 'package:reciclapp/auth_service.dart';
import 'package:reciclapp/custom_bottom_nav_bar_collector.dart'; // Importa tu servicio de autenticación

class ProfileCollectorScreen extends StatelessWidget {
  const ProfileCollectorScreen({super.key});

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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
                0xFF104B28), // Cambia el color del botón si lo deseas
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBarCollector(currentIndex: 3),
    );
  }
}
