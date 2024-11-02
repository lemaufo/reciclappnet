import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:reciclapp/custom_bottom_nav_bar.dart';

// class ScanScreen extends StatelessWidget {
//   const ScanScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context)
//               .scaffoldBackgroundColor, // Fondo transparente para que combine con la pantalla
//           elevation: 0, // Sin sombra
//           toolbarHeight: 78.0,
//           title: const Text('Escanear',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//         ),
//         body: Container(),
//         bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2));
//   }
// }

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? barcodeResult;

  Future<void> scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        barcodeResult = result.rawContent;
      });
    } catch (e) {
      setState(() {
        barcodeResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Códigos de Barras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (barcodeResult != null) ...[
              const Text(
                'Resultado del escaneo:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                barcodeResult!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text('Escanear Código de Barras'),
            ),
          ],
        ),
      ),
    );
  }
}
