import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reciclapp/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String name, required String photo});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? photo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar los datos del usuario desde shared_preferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name =
          prefs.getString('name') ?? 'Usuario'; // Valor por defecto 'Usuario'
      photo = prefs.getString('photo') ?? ''; // Foto por defecto vacía
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 78.0,
        title: Padding(
          padding: const EdgeInsets.only(
            top: 28.0,
            left: 2.0,
            right: 2.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: (photo != null && photo!.isNotEmpty)
                        ? NetworkImage(photo!)
                        : const AssetImage('assets/profile.png')
                            as ImageProvider, // Si no hay foto, usa una imagen por defecto
                    radius: 25,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $name',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Nunito',
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Empieza a reciclar!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFC0EE54).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF104B28),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context,
                        '/notifications'); // Acción al presionar el ícono de notificaciones
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Reciclapp!',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
