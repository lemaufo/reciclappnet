import 'package:flutter/material.dart';
import 'package:reciclapp/custom_bottom_nav_bar.dart';
import 'package:reciclapp/auth_service.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await AuthService().fetchCategories();
      setState(() {
        categories = response;
      });
    } catch (error) {
      // ignore: avoid_print
      print('Error al cargar categorías: $error');
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
              Navigator.pushReplacementNamed(context, '/bag');
            },
          ),
        ),
        toolbarHeight: 78.0,
        title: const Text(
          'Contenedor',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: categories.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: ListTile(
                          leading: Image.network(
                            category['image_url'] ?? '',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image, size: 100),
                          ),
                          title: Text(
                            'Bolsa de ${category['name']}',
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
                                  categoryName: category['name'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción del botón
                Navigator.pushReplacementNamed(context, '/request');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF104B28),
                foregroundColor: const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ), // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
              ),
              child: const Text(
                'Solicitar recolección',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text(
          'Contenido para la categoría: $categoryName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
