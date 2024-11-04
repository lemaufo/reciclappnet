import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reciclapp/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String _errorMessage = '';

  final AuthService _authService =
      AuthService(); // Instancia del servicio de autenticación

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin(BuildContext context, String email, String password) async {
    final loginResponse = await _authService.login(email, password);

    if (loginResponse['success'] == true) {
      int rolId = loginResponse['user']['rol_id'];

      // Redirigir a la pantalla correspondiente según el rol
      if (rolId == 2) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/homecollector'); // Recolector
      } else if (rolId == 3) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home'); // Usuario estándar
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login'); // Otros roles
      }
    } else {
      // Mostrar un mensaje de error si las credenciales son incorrectas
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(loginResponse['error'] ?? 'Error al iniciar sesión')),
      );
    }
  }

// Método de inicio de sesión actualizado
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Reinicia el mensaje de error
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Usar el método handleLogin para manejar la redirección según el rol
      handleLogin(context, email, password);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 31.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Inicio de sesión',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 54.0),
              Center(
                child: Image.asset(
                  'assets/reciclapphandsgreen_logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 54.0),
              Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu correo electrónico',
                  filled: true, // Habilita el color de fondo
                  fillColor: Color(0xFFF2F2F2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  prefixIcon: Icon(Icons.email_outlined,
                      color: const Color(0xFF104B28)),
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      100), // Limita la entrada a 100 caracteres
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  // Expresión regular para validar el correo con las reglas especificadas:
                  final emailRegex = RegExp(
                      r"^(?!.*[.]{2})(?![-_.])(?!.*[-_.]$)[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$");
                  // Validar si el correo cumple con el patrón
                  if (!emailRegex.hasMatch(value)) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  if (value.length < 6) {
                    return 'El correo debe tener al menos 6 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  filled: true, // Habilita el color de fondo
                  fillColor: Color(0xFFF2F2F2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outlined,
                    color: Color(0xFF104B28),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      128), // Limita la entrada a 128 caracteres
                ],
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              if (_errorMessage.isNotEmpty) // Mostrar el mensaje de error
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 40.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Indicador de carga
                  : SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF104B28),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 118.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una cuenta? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      'Regístrate aquí',
                      style: TextStyle(
                        color: Color(0xFF104B28),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
