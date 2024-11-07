import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reciclapp/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // bool _obscureTextPassword = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');

    setState(() {
      _nameController.text = name ?? '';
      _phoneController.text = phone ?? '';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String phone = _phoneController.text;
      final String password = _passwordController.text;

      try {
        final result = await AuthService().updateProfile(name, phone, password);

        if (result['error'] != null) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['error'])),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado con éxito')),
          );
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: $error')),
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
        leading: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xFF000000),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ),
        toolbarHeight: 78.0,
        title: const Text(
          'Editar perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 31.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50.0),
                    const Text(
                      'Datos personales',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        // hintText: 'Ingresa tu nombre',
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
                        prefixIcon: const Icon(Icons.person_outlined,
                            color: Color(0xFF104B28)),
                        suffixIcon:
                            const Icon(Icons.edit, color: Color(0xFF104B28)),
                      ),
                      keyboardType: TextInputType.name,
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu nombre';
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
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        // hintText: 'Ingresa tu número de teléfono',
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
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: Color(0xFF104B28)),
                        suffixIcon:
                            const Icon(Icons.edit, color: Color(0xFF104B28)),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
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
                    const SizedBox(height: 30.0),
                    const Text(
                      'Opcional',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      // controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Cambiar contraseña',
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8.0),
                        //   borderSide: BorderSide(color: Colors.transparent),
                        // ),
                        prefixIcon: const Icon(Icons.lock_outlined,
                            color: Color(0xFF104B28)),
                        suffixIcon:
                            const Icon(Icons.edit, color: Color(0xFF104B28)),
                      ),
                      // obscureText: true,
                      readOnly: true,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/reset_password');
                      },
                    ),
                    const SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF104B28),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 35.0),
                        ),
                        child: const Text(
                          'Actualizar perfil',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
    );
  }
}
