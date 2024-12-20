import 'package:flutter/material.dart';
import 'package:reciclapp/auth_service.dart';
import 'package:reciclapp/custom_bottom_nav_bar_collector.dart';
import 'package:reciclapp/view_map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenCollector extends StatefulWidget {
  const HomeScreenCollector(
      {super.key, required String name, required String photo});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenCollectorState createState() => _HomeScreenCollectorState();
}

class _HomeScreenCollectorState extends State<HomeScreenCollector> {
  String? name;
  String? photo;
  List<Map<String, dynamic>> requests = []; // Lista de solicitudes
  bool isLoading = true;
  String errorMessage = ''; // Mensaje de error

  final List<String> _imagePaths = [
    'assets/plastic.png',
    'assets/glass.png',
    'assets/aluminum.png',
    'assets/cardboard.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Usuario';
      photo = prefs.getString('photo') ?? '';
    });

    int userId = prefs.getInt('user_id') ?? 0;
    if (userId == 0) {
      setState(() {
        errorMessage = 'Error: user_id no encontrado en SharedPreferences.';
        isLoading = false;
      });
    } else {
      await _fetchAllRequests();
    }
  }

  Future<void> _fetchAllRequests() async {
    try {
      List<Map<String, dynamic>> result =
          await AuthService().fetchAllRequests();
      setState(() {
        requests = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar todas las solicitudes: $e';
        isLoading = false;
      });
      print('Error al obtener todas las solicitudes: $e');
    }
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
                            as ImageProvider,
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
                    Navigator.pushReplacementNamed(
                        context, '/notificationscollector');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _imagePaths.map((imagePath) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Solicitudes de recolección',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : requests.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .move_to_inbox_outlined, // Cambia este ícono por el que prefieras
                                    size: 50.0,
                                    color: Colors
                                        .grey, // Color con opacidad similar al texto
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "No tienes solicitudes realizadas",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                final request = requests[index];
                                final latitude =
                                    double.tryParse(request['latitude']) ?? 0.0;
                                final longitude =
                                    double.tryParse(request['longitude']) ??
                                        0.0;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${request['code']}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Estatus: ${request['status']}'),
                                      Text(
                                          'Fecha de solicitud: ${request['date']}'),
                                      Text('Hora: ${request['hour']}'),
                                      Text(
                                          'Fecha de recolección: ${request['scheduled_date']}'),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Ícono del mapa
                                          IconButton(
                                            icon: const Icon(
                                              Icons.map_outlined,
                                              color: Color(0xFF104B28),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapViewScreen(
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            children: [
                                              // Botón de Rechazar
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  bool success =
                                                      await AuthService()
                                                          .updateRequestStatus(
                                                              request['code'],
                                                              'Rechazado');
                                                  if (success) {
                                                    setState(() {
                                                      request['status'] =
                                                          'Rechazado'; // Actualiza el estado localmente
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Solicitud rechazada exitosamente.')),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error al rechazar la solicitud.')),
                                                    );
                                                  }
                                                },
                                                child: const Text('Rechazar'),
                                              ),
                                              const SizedBox(width: 8),
                                              // Botón de Aceptar
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF104B28),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  bool success =
                                                      await AuthService()
                                                          .updateRequestStatus(
                                                              request['code'],
                                                              'Aceptado');
                                                  if (success) {
                                                    setState(() {
                                                      request['status'] =
                                                          'Aceptado'; // Actualiza el estado localmente
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Solicitud aceptada exitosamente.')),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Error al aceptar la solicitud.')),
                                                    );
                                                  }
                                                },
                                                child: const Text('Aceptar'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBarCollector(currentIndex: 0),
    );
  }
}
