import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

// ignore: use_key_in_widget_constructors
class MapScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng selectedLocation =
      LatLng(16.9034965, -92.1019357); // Coordenadas iniciales

  // Configuración inicial del mapa cuando se crea
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Actualiza la ubicación seleccionada y muestra las coordenadas en consola
  void _onMapTapped(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
    // ignore: avoid_print
    print(
        'Ubicación seleccionada: Latitud ${location.latitude}, Longitud ${location.longitude}');
  }

// Función para seleccionar la ubicación y regresar el nombre al `TextField`
  Future<void> _selectLocation() async {
    // Convierte las coordenadas a una dirección legible
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    // Imprime las coordenadas en consola
    // ignore: avoid_print
    print(
        'Ubicación seleccionada: Latitud ${selectedLocation.latitude}, Longitud ${selectedLocation.longitude}');

    // Crea el resultado con nombre y coordenadas
    final result = {
      'locationName': placemarks.isNotEmpty
          ? placemarks.first.locality
          : "Ubicación desconocida",
      'latitude': selectedLocation.latitude,
      'longitude': selectedLocation.longitude,
    };

    // Retorna los datos al cerrar la pantalla
    // ignore: use_build_context_synchronously
    Navigator.pop(context, result);
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
              Navigator.pushReplacementNamed(context, '/request');
            },
          ),
        ),
        toolbarHeight: 78.0,
        title: const Text('Seleccionar ubicación',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0)),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Mapa de Google con marcador en la ubicación seleccionada
          GoogleMap(
            onMapCreated: _onMapCreated,

            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 14,
            ),
            onTap:
                _onMapTapped, // Detecta toques en el mapa y actualiza la ubicación seleccionada
            markers: {
              Marker(
                markerId: MarkerId("selected-location"),
                position: selectedLocation,
              ),
            },
          ),
          // Botón para confirmar y regresar el nombre de la ubicación
          Positioned(
            bottom: 30,
            left: 90,
            right: 90,
            child: ElevatedButton(
              onPressed: _selectLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF104B28),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0), // Espacio interno del botón
                elevation: 0, // Sombra del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
              child: Text(
                "Aceptar ubicación",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
