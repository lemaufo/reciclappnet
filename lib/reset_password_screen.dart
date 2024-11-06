import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureTextCurrent = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xFF000000),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/edit_profile');
            },
          ),
        ),
        toolbarHeight: 78.0,
        title: const Text(
          'Cambiar contraseña',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Contraseña Actual
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  hintText: 'Contraseña actual',
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xFF104B28)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextCurrent
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextCurrent = !_obscureTextCurrent;
                      });
                    },
                  ),
                ),
                obscureText: _obscureTextCurrent,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña actual';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),

              // Campo de Nueva Contraseña
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: 'Nueva contraseña',
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xFF104B28)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextNew ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextNew = !_obscureTextNew;
                      });
                    },
                  ),
                ),
                obscureText: _obscureTextNew,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una nueva contraseña';
                  } else if (value.length < 8) {
                    return 'La nueva contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),

              // Campo de Confirmar Contraseña
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirmar nueva contraseña',
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Color(0xFF104B28)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF104B28),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirm = !_obscureTextConfirm;
                      });
                    },
                  ),
                ),
                obscureText: _obscureTextConfirm,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirma tu nueva contraseña';
                  } else if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),

              // Botón para guardar cambios
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lógica para actualizar la contraseña
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF104B28),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 35.0),
                ),
                child: Text(
                  "Guardar cambios",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
