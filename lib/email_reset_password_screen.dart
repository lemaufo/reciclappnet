import 'package:flutter/material.dart';
import 'package:reciclapp/register_screen.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _emailErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    setState(() {
      _emailErrorMessage = null; // Reiniciar el mensaje de error
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Aquí llamarías a la API para enviar el código de recuperación al email

      setState(() {
        _isLoading = false;
      });

      // Redirigir a la pantalla donde se ingresa el código y la nueva contraseña
      Navigator.pushReplacementNamed(context, '/enterResetCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 24.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xFF104B28),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
      ),
      body: Container(),
    );
  }
}
