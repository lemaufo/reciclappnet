import 'package:flutter/material.dart';
// import 'package:reciclapp/custom_bottom_nav_bar.dart';
// import 'package:reciclapp/auth_service.dart';

class ContainerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> materials;

  const ContainerScreen({super.key, required this.materials});

  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
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
              Navigator.pop(context);
            },
          ),
        ),
        toolbarHeight: 78.0,
        title: const Text(
          'Contenedor',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: widget.materials.isEmpty
          ? const Center(child: Text('El contenedor está vacío.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.materials.length,
                    itemBuilder: (context, index) {
                      final material = widget.materials[index];
                      final imageUrl = material['material_image'] != null
                          ? 'https://reciclapp.net/${material['material_image']}'
                          : 'https://reciclapp.net/default/profile.png';
                      final description =
                          material['material_description'] ?? 'Sin descripción';
                      final quantity = material['quantity'] ?? 0;

                      return ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(description),
                        trailing: Text('Cantidad: $quantity'),
                      );
                    },
                  ),
                ),
                // Botón para solicitar recolección
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar a la vista de solicitud de recolección
                      Navigator.pushNamed(context, '/request');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF104B28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text(
                      'Solicitar recolección',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
