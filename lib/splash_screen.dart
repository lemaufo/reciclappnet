import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reciclapp/auth_service.dart'; // Importa tu servicio de autenticación

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ignore: unused_field
  bool _logoCentered = false;
  bool _logoLeft = false;
  double _textOpacity = 0.0;
  double _textPosition = 0.9;
  double _logoTopPosition = -100;

  @override
  void initState() {
    super.initState();

    // Iniciar la animación después de 1 segundo
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _logoCentered = true;
        _logoTopPosition = MediaQuery.of(context).size.height / 2 - 40;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _logoLeft = true;
          _textOpacity = 1.0;
          _textPosition = MediaQuery.of(context).size.width / 2 - 30;
        });

        // Verifica si el usuario está logueado
        _checkLoginStatus();
      });
    });
  }

  // Verificar si el usuario ya está logueado
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().isLoggedIn();

    // Después de otros 2 segundos, navegar a la pantalla correspondiente
    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        // Si el usuario está logueado, ir a la pantalla de inicio
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Si no está logueado, ir a la pantalla de login
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF104B28),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _logoTopPosition,
            left: _logoLeft
                ? MediaQuery.of(context).size.width / 2 - 140
                : MediaQuery.of(context).size.width / 2 - 40,
            child: Image.asset(
              'assets/reciclapphands_logo.png',
              width: 80,
              height: 80,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _logoTopPosition + 8,
            left: _textPosition,
            child: AnimatedOpacity(
              opacity: _textOpacity,
              duration: const Duration(seconds: 1),
              child: const Text(
                "reciclapp",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC0EE54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
