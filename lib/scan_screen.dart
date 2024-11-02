import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scanBarcode();
    });
  }

  Future<void> scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();

      if (result.rawContent.isNotEmpty) {
        showResultModal(result.rawContent);
      } else {
        // Si el usuario cancela, redirige a la pantalla '/home'
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // En caso de error, muestra el modal con el error y redirige a '/home' al cerrarlo
      showResultModal('Error: $e');
    }
  }

  void showResultModal(String result) {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // Permitir cerrar el modal al tocar afuera
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Resultado del escaneo:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                result,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el modal
                  Navigator.pushReplacementNamed(
                      context, '/bag'); // Ir a la ruta '/bag'
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      // Redirigir a '/home' cuando el modal se cierra
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors
          .transparent, // Fondo transparente para ocultar cualquier vista de fondo
    );
  }
}
