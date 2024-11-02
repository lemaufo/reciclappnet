import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reciclapp/login_screen.dart';
import 'package:reciclapp/auth_service.dart';
// Asegúrate de importar el servicio de autenticación

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String phone = _phoneController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String confirmPassword = _passwordConfirmController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      try {
        final result = await AuthService().register(
            name, // Nombre del usuario
            phone, // Número de teléfono
            email, // Correo electrónico
            password, // Contraseña
            3 // Id del rol
            );

        if (result['error'] != null) {
          // Mostrar el error devuelto por el servicio de autenticación
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['error'])),
          );
        } else {
          // Si no hay error, continuar con el registro exitoso
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso')),
          );

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el registro: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        // leading: Padding(
        //   padding: const EdgeInsets.only(top: 20.0, left: 24.0),
        //   child: IconButton(
        //     icon: const Icon(Icons.arrow_back_ios),
        //     color: const Color(0xFF104B28),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 31.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 1.0),
              const Text(
                'Regístrate',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 23.0),
              Text(
                'Nombre completo', // El texto que deseas mostrar
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28), // Color del texto
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu nombre completo',
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
                  prefixIcon: Icon(Icons.person_outlined,
                      color: const Color(0xFF104B28)),
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      100), // Limita la entrada a 100 caracteres
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre completo';
                  }
                  if (value.length > 100) {
                    return 'El nombre no puede tener más de 100 caracteres';
                  }
                  if (value.length < 3) {
                    return 'El nombre no puede tener menos de 3 caracteres';
                  }
                  if (!RegExp(r"^[a-zA-ZÀ-ÿ\u00f1\u00d1\s]+$")
                      .hasMatch(value)) {
                    return 'El nombre solo puede contener letras y espacios';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Text(
                'Teléfono', // El texto que deseas mostrar
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28), // Color del texto
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu número de teléfono',
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
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: const Color(0xFF104B28)),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      10), // Limita la entrada a 10 caracteres
                  FilteringTextInputFormatter
                      .digitsOnly, // Permite solo números
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu número de teléfono';
                  }
                  if (value.length != 10) {
                    return 'El número debe tener exactamente 10 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Text(
                'Email', // El texto que deseas mostrar
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28), // Color del texto
                ),
              ),
              const SizedBox(height: 10.0),
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
              const SizedBox(height: 10.0),
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 10.0),
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
                      _obscureTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextPassword = !_obscureTextPassword;
                      });
                    },
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      128), // Limita la entrada a 128 caracteres
                ],
                obscureText: _obscureTextPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  // Expresión regular que permite letras, números, y ciertos caracteres especiales
                  final passwordRegex =
                      RegExp(r'^[a-zA-Z0-9@#\$%\^&\*\(\)_\+\-\?!]+$');
                  // Verificar si la contraseña contiene caracteres no permitidos
                  if (!passwordRegex.hasMatch(value)) {
                    return 'Solo se acepta: @, #, %, ^, &, *, (, ), -, _, +, !, ?.';
                  }
                  // Verificar que la contraseña no tenga espacios
                  if (value.contains(' ')) {
                    return 'Las contraseñas no deben contener espacios';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Confirmar contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  fontSize: 20.0,
                  color: Color(0xFF104B28),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  hintText: 'Repite tu contraseña',
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
                      _obscureTextConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirmPassword =
                            !_obscureTextConfirmPassword;
                      });
                    },
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      128), // Limita la entrada a 128 caracteres
                ],
                obscureText: _obscureTextConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  // Expresión regular que permite letras, números, y ciertos caracteres especiales
                  final passwordRegex =
                      RegExp(r'^[a-zA-Z0-9@#\$%\^&\*\(\)_\+\-\?!]+$');
                  // Verificar si la contraseña contiene caracteres no permitidos
                  if (!passwordRegex.hasMatch(value)) {
                    return 'Solo se acepta: @, #, %, ^, &, *, (, ), -, _, +, !, ?.';
                  }
                  // Verificar que la contraseña no tenga espacios
                  if (value.contains(' ')) {
                    return 'Las contraseñas no deben contener espacios';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Container(
                alignment: Alignment.center, // Alinea el contenido al centro
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centra verticalmente
                  children: [
                    Text(
                      'Al crear una cuenta, aceptas nuestros ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centrar el texto
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/privacyandterms');
                      },
                      child: Text(
                        'Términos y condiciones.',
                        style: TextStyle(
                          color: Color(0xFF104B28),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center, // Centrar el texto
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF104B28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Registrarme',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Ya tienes una cuenta? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Inicia sesión aquí',
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
