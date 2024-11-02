import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reciclapp/auth_service.dart'; // Importar AuthService
import 'package:reciclapp/email_reset_password_screen.dart';
import 'package:reciclapp/home_screen_collector.dart';
import 'package:reciclapp/learn_screen_collector.dart';
import 'package:reciclapp/notifications_collector_screen.dart';
import 'package:reciclapp/notifications_screen.dart';
import 'package:reciclapp/privacy_and_terms_screen.dart';
import 'package:reciclapp/profile_screen_collector.dart';
// import 'package:reciclapp/requests_collector_screen.dart';
import 'package:reciclapp/requestscreen.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'learn_screen.dart';
import 'scan_screen.dart';
import 'bag_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const ReciclApp());
}

class ReciclApp extends StatelessWidget {
  const ReciclApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', 'ES'), // Establecer idioma a español
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
        const Locale('en', 'US'), // Inglés
      ],
      debugShowCheckedModeBanner: false,
      title: 'Reciclapp',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: FutureBuilder<String>(
        future:
            _determineInitialScreen(), // Espera la ruta de la pantalla inicial
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Mostrar la pantalla de Splash mientras espera
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al determinar la pantalla inicial'),
            );
          } else {
            // Redirigir a la pantalla adecuada tras un pequeño delay
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Future.delayed(const Duration(
                  seconds: 2)); // Mostrar Splash mínimo 2 segundos
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, snapshot.data!);
            });
            return const SplashScreen(); // Mantener la pantalla de Splash mientras espera
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(
              name: '',
              photo: '',
            ),
        '/learn': (context) => const LearnScreen(),
        '/scan': (context) => const ScanScreen(),
        '/bag': (context) => const BagScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/homecollector': (context) => const HomeScreenCollector(
              name: '',
              photo: '',
            ),
        '/learncollector': (context) => const LearnCollectorScreen(),
        '/profilecollector': (context) => const ProfileCollectorScreen(),
        '/privacyandterms': (context) => const PrivacyAndTermsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/notificationscollector': (context) =>
            const NotificationsCollectorScreen(),
        '/emailresetpassword': (context) => PasswordRecoveryScreen(),
        '/request': (context) => RequestScreen(),
      },
    );
  }

  // Método para determinar la pantalla inicial según el estado de autenticación
  Future<String> _determineInitialScreen() async {
    AuthService authService = AuthService();

    // Verificar si el usuario está autenticado
    bool isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      // Si está autenticado, obtenemos los datos del usuario
      final userData = await authService.getUserData();
      final int? rolId = userData['rol_id'];

      // Retornar la ruta de acuerdo al rol del usuario
      if (rolId == 2) {
        return '/homecollector'; // Rol de Recolector
      } else {
        return '/home'; // Rol de Usuario estándar
      }
    } else {
      // Si no está autenticado, redirigir al login
      return '/login';
    }
  }
}
