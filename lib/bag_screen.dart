import 'package:flutter/material.dart';
import 'package:reciclapp/custom_bottom_nav_bar.dart';
import 'package:reciclapp/auth_service.dart'; // Importa auth_service.dart para manejar la API

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BagScreenState createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  List<Map<String, dynamic>> categories = []; // Lista para almacenar categorías

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Llamar a la función para cargar categorías al iniciar
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await AuthService()
          .fetchCategories(); // Llama a la función de tu API en auth_service.dart
      setState(() {
        categories = response; // Actualiza la lista con los datos de la API
      });
    } catch (error) {
      // Manejar errores
      // ignore: avoid_print
      print('Error al cargar categorías: $error');
      print('Categorías cargadas: $categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 78.0,
        title: const Text(
          'Bolsa',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: categories.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Muestra un indicador mientras se cargan los datos
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 50.0), // Espacio entre elementos
                  child: ListTile(
                    leading: (category['image'] != null)
                        ? Image.network(
                            'https://reciclapp.net${category['image']}',
                            width: 70,
                            // height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image,
                              size: 100,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 100,
                          ),
                    title: Text(
                      'Bolsa de ${category['name'] ?? 'Sin nombre'}', // Nombre de la categoría
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(
                            categoryName: category['name'] ?? 'Sin nombre',
                            materialDescription: '',
                            materialImage: '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            right: 16.0), // Ajusta la posición del conjunto (botón + texto)
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Evita que el Row ocupe todo el ancho
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0), // Añade padding alrededor del texto
              decoration: BoxDecoration(
                color: Colors.white, // Fondo para que el texto resalte
                borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
              ),
              child: Text(
                'Ver contenedor', // Mensaje estático al lado del botón
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Cambia el color según tu diseño
                ),
              ),
            ),
            const SizedBox(width: 0), // Espacio entre el texto y el botón
            SizedBox(
              width: 80, // Ajusta el ancho del botón
              height: 80, // Ajusta el alto del botón
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/container');
                },
                backgroundColor: Color(0xFF104B28),
                child: const Icon(
                  Icons.delete,
                  color: Color(0xFFC0EE54),
                  size: 40, // Ajusta el tamaño del ícono dentro del botón
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}

// class CategoryDetailScreen extends StatelessWidget {
//   final String categoryName;
//   final String materialDescription;
//   final String materialImage;

//   const CategoryDetailScreen({
//     super.key,
//     required this.categoryName,
//     required this.materialDescription,
//     required this.materialImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(top: 2),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             color: const Color(0xFF000000),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/bag');
//             },
//           ),
//         ),
//         toolbarHeight: 78.0,
//         title: Text(
//           'Detalles',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
//         ),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.network(
//               'https://reciclapp.net/$materialImage',
//               width: 100,
//               height: 100,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Icon(
//                 Icons.image,
//                 size: 100,
//               ),
//             ), // Imagen del material
//             const SizedBox(height: 20),
//             Text(
//               materialDescription,
//               style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Bolsa de $categoryName',
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final String materialDescription;
  final String materialImage;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.materialDescription,
    required this.materialImage,
  });

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Map<String, dynamic>> scannedMaterials = [];

  @override
  void initState() {
    super.initState();
    fetchScannedMaterials();
  }

  Future<void> fetchScannedMaterials() async {
    int? userId = await AuthService().getCurrentUserId();

    if (userId != null) {
      scannedMaterials = await AuthService().getScannedMaterials(userId);
      setState(() {});
    } else {
      print(
          'Error: El userId es nulo. No se puede obtener los materiales escaneados.');
      // Muestra un mensaje de error o redirige al usuario para iniciar sesión de nuevo.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF000000),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/bag');
          },
        ),
        title: Text(
          'Detalles de ${widget.categoryName}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: scannedMaterials.isEmpty
          ? Center(child: Text('No hay materiales escaneados disponibles.'))
          : ListView.builder(
              itemCount: scannedMaterials.length,
              itemBuilder: (context, index) {
                final material = scannedMaterials[index];

                // Manejamos valores potencialmente nulos con valores por defecto
                final imageUrl = material['material_image'] != null
                    ? 'https://reciclapp.net/${material['material_image']}'
                    : 'https://reciclapp.net/default_image.png'; // Imagen por defecto

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
    );
  }
}
