import 'package:flutter/material.dart';
import 'package:reciclapp/auth_service.dart';
import 'package:reciclapp/custom_bottom_nav_bar_collector.dart';
import 'package:reciclapp/view_map_screen.dart';

class RequestsCollectorScreen extends StatefulWidget {
  const RequestsCollectorScreen({super.key});

  @override
  _RequestsCollectorScreenState createState() =>
      _RequestsCollectorScreenState();
}

class _RequestsCollectorScreenState extends State<RequestsCollectorScreen> {
  List<Map<String, dynamic>> requests = []; // Lista de solicitudes
  bool isLoading = true;
  String errorMessage = ''; // Mensaje de error

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
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
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // Fondo transparente
        elevation: 0, // Sin sombra

        toolbarHeight: 78.0,
        title: const Text(
          'Solicitudes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : requests.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.move_to_inbox_outlined,
                            size: 50.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No tienes solicitudes realizadas",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: requests.length,
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final latitude =
                            double.tryParse(request['latitude']) ?? 0.0;
                        final longitude =
                            double.tryParse(request['longitude']) ?? 0.0;
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text('Fecha de solicitud: ${request['date']}'),
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
                                          builder: (context) => MapViewScreen(
                                            latitude: latitude,
                                            longitude: longitude,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool success = await AuthService()
                                              .updateRequestStatus(
                                                  request['code'], 'Rechazado');
                                          if (success) {
                                            setState(() {
                                              request['status'] = 'Rechazado';
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Solicitud rechazada exitosamente.')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Error al rechazar la solicitud.')),
                                            );
                                          }
                                        },
                                        child: const Text('Rechazar'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF104B28),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool success = await AuthService()
                                              .updateRequestStatus(
                                                  request['code'], 'Aceptado');
                                          if (success) {
                                            setState(() {
                                              request['status'] = 'Aceptado';
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Solicitud aceptada exitosamente.')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
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
      bottomNavigationBar: const CustomBottomNavBarCollector(currentIndex: 2),
    );
  }
}
