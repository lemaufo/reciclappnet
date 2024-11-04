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
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: double.infinity, // Ocupa todo el ancho de la pantalla
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'Elemento encontrado:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                result,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'En este apartado se presenta la descripción del elemento encontrado.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el modal
                  Navigator.pushReplacementNamed(
                      context, '/bag'); // Ir a la ruta '/bag'
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF104B28),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(), // Forma circular
                  padding: const EdgeInsets.all(16), // Tamaño del botón
                ),
                child: const Icon(Icons.arrow_forward_ios,
                    size: 24), // Ícono de flecha
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/bag');
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
