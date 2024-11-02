// import 'package:flutter/material.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   final String email;

//   const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   String _message = '';

//   Future<void> resetPassword() async {
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;

//     if (password == confirmPassword) {
//       // Hacer una petición POST a tu API para actualizar la contraseña
//       final response = await http.post(
//         Uri.parse(
//             'https://tu-api.com/reset-password'), // Reemplaza con tu endpoint
//         body: {'email': widget.email, 'password': password},
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _message = 'Contraseña actualizada correctamente.';
//         });
//         Navigator.pushNamed(context, '/login');
//       } else {
//         setState(() {
//           _message = 'Error al actualizar la contraseña.';
//         });
//       }
//     } else {
//       setState(() {
//         _message = 'Las contraseñas no coinciden.';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Restablecer Contraseña')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Nueva contraseña'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration:
//                   InputDecoration(labelText: 'Confirmar nueva contraseña'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: resetPassword,
//               child: Text('Restablecer contraseña'),
//             ),
//             SizedBox(height: 20),
//             Text(_message),
//           ],
//         ),
//       ),
//     );
//   }
// }
