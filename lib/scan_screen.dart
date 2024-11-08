import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:reciclapp/auth_service.dart';
import 'package:reciclapp/bag_screen.dart';

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

  void showResultModal(String materialCode) async {
    try {
      final result = await AuthService().verifyMaterial(materialCode);
      int? userId = await AuthService().getCurrentUserId(); // Obtén el userId
      List<Map<String, dynamic>> searchResults = [];
      TextEditingController searchController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled:
            true, // Permite que el modal sea más largo y se ajuste al teclado
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              Future<void> searchMaterials(String query) async {
                if (query.isNotEmpty) {
                  searchResults = await AuthService().searchMaterials(query);
                  setState(() {});
                }
              }

              return Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      20, // Ajuste para que no sea cubierto por el teclado
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          result['success']
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: result['success'] ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          result['success']
                              ? 'Elemento encontrado'
                              : 'Elemento no encontrado',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      result['message'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (result['success'] && result['description'] != null)
                      Text(
                        result['description'],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    if (!result['success']) ...[
                      const SizedBox(height: 20),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Buscar materiales similares',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          searchMaterials(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      if (searchResults.isNotEmpty)
                        Column(
                          children: searchResults.map((material) {
                            return ListTile(
                              title: Text(material['name']),
                              subtitle: Text(material['description']),
                              onTap: () {
                                print(
                                    'Material seleccionado: ${material['name']}');
                                Navigator.pushReplacementNamed(context, '/bag');
                              },
                            );
                          }).toList(),
                        ),
                      if (searchResults.isEmpty &&
                          searchController.text.isNotEmpty)
                        Text(
                          'No se encontraron materiales similares',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (result['success']) {
                          print('userId: $userId');
                          if (userId != null) {
                            // Verificamos que los valores críticos no sean null antes de proceder
                            final image = result['image'];
                            final description = result['description'];
                            final categoryId = result['material_category_id'];
                            if (image != null &&
                                description != null &&
                                categoryId != null) {
                              try {
                                bool success =
                                    await AuthService().saveScannedMaterial({
                                  'material_image': image,
                                  'material_description': description,
                                  'quantity': 1,
                                  'user_id': userId,
                                  'category_id': categoryId,
                                });

                                if (success) {
                                  String categoryName;
                                  switch (categoryId) {
                                    case 1:
                                      categoryName = 'Aluminio';
                                      break;
                                    case 2:
                                      categoryName = 'Vidrio';
                                      break;
                                    case 3:
                                      categoryName = 'Plástico';
                                      break;
                                    default:
                                      categoryName = 'Otra Categoría';
                                  }
                                  print('Description: $description');
                                  print('Image: $image');
                                  print('Category ID: $categoryId');

                                  // Navegar a CategoryDetailScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryDetailScreen(
                                        categoryName: categoryName,
                                        materialDescription: description,
                                        materialImage: image,
                                      ),
                                    ),
                                  );
                                } else {
                                  print(
                                      'Error: no se pudo guardar el material.');
                                }
                              } catch (e) {
                                print(
                                    'Error al guardar el material escaneado Modal: $e');
                              }
                            } else {
                              print(
                                  'Error: Uno o más valores de material escaneado son nulos. No se puede proceder.');
                            }
                          } else {
                            print(
                                'Error: userId es nulo. No se puede guardar el material escaneado.');
                          }
                        } else {
                          Navigator.pushReplacementNamed(context, '/scan');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF104B28),
                        foregroundColor: Colors.white,
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Icon(
                        result['success']
                            ? Icons.arrow_forward_ios
                            : Icons.refresh,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error al verificar el material: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors
          .transparent, // Fondo transparente para ocultar cualquier vista de fondo
    );
  }
}
