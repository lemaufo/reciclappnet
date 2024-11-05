import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reciclapp/custom_bottom_nav_bar.dart';
import 'package:reciclapp/map_screen.dart';
import 'package:geolocator/geolocator.dart';

class RequestScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const RequestScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RequestScreenState createState() {
    return _RequestScreenState();
  }
}

class _RequestScreenState extends State<RequestScreen> {
  String locationName = "Buscar ubicaciones";

  // Función para abrir el mapa y seleccionar una ubicación
  Future<void> _openMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        locationName = selectedLocation; // Actualiza el nombre en el TextField
      });
    }
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    // ignore: avoid_print
    print('Ubicación actual: $position');
    setState(() {
      locationName = "Usando mi ubicación actual";
    });
  }

  DateTime selectedDate = DateTime.now();

  TextEditingController timePicker = TextEditingController();

  // Generar la lista de horarios de cada media hora entre 6:00 AM y 6:00 PM
  List<String> _generateHalfHourIntervals() {
    List<String> times = [];

    // Horarios AM (6:00 AM a 11:30 AM)
    for (int hour = 7; hour < 12; hour++) {
      times.add("${TimeOfDay(hour: hour, minute: 0).format(context)} AM");
      times.add("${TimeOfDay(hour: hour, minute: 30).format(context)} AM");
    }

    // Horarios PM (12:00 PM a 6:00 PM)
    for (int hour = 12; hour <= 17; hour++) {
      // Para la hora 12, se mantiene como "12:00 PM", y para las siguientes horas, mostramos "01:00 PM", "02:00 PM", etc.
      int displayHour = hour > 12 ? hour - 12 : hour; // Convertir 13-18 a 1-6
      times
          .add("${TimeOfDay(hour: displayHour, minute: 0).format(context)} PM");
      times.add(
          "${TimeOfDay(hour: displayHour, minute: 30).format(context)} PM");
    }

    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context)
              .scaffoldBackgroundColor, // Fondo transparente para que combine con la pantalla
          elevation: 0, // Sin sombra
          leading: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0xFF000000),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/container');
              },
            ),
          ),
          toolbarHeight: 78.0,
          title: const Text('Solicitar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 31.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Elige una fecha',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 13.0),
                TextField(
                  readOnly: true, // Campo de solo lectura
                  onTap: () async {
                    // Obtener el último día del mes siguiente al actual
                    DateTime lastDate = DateTime(
                      DateTime.now().year,
                      DateTime.now().month + 2, // El mes siguiente
                      0, // Esto obtiene el último día del mes anterior, en este caso el mes siguiente
                    );
                    // Mostrar el calendario para que el usuario elija una fecha
                    final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate:
                          DateTime.now(), // La fecha mínima será hoy o después
                      lastDate: lastDate,
                    );

                    // Validar la fecha seleccionada
                    if (dateTime != null) {
                      if (dateTime.weekday == DateTime.sunday) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No se pueden seleccionar domingos"),
                          ),
                        );
                      } else {
                        // Si es válida, actualizar el estado
                        setState(() {
                          selectedDate = dateTime;
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    // Color de fondo
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent, // Color del borde
                        // Grosor del borde
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(
                            0xFF104B28), // Color del borde cuando está enfocado
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today,
                        color: Color(0xFF104B28)), // Ícono a la izquierda
                    // ignore: unnecessary_null_comparison
                    hintText: selectedDate != null
                        ? DateFormat('EEEE, MMMM d, yyyy', 'es').format(
                            selectedDate) // Formato de la fecha seleccionada
                        : "Elige una fecha", // Texto por defecto si no hay fecha seleccionada
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Elige una hora',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 13.0),
                TextField(
                  readOnly: true, // Campo de solo lectura
                  controller: timePicker,
                  onTap: () async {
                    // Mostrar la lista de horarios con validación
                    List<String> times = _generateHalfHourIntervals();

                    await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView.builder(
                          itemCount: times.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(times[index]),
                              onTap: () {
                                // Actualizar el controlador con la hora seleccionada
                                setState(() {
                                  timePicker.text = times[index];
                                });
                                Navigator.pop(context); // Cerrar el modal
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,

                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent, // Color del borde
                        // Grosor del borde
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(
                            0xFF104B28), // Color del borde cuando está enfocado
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.schedule,
                        color: Color(0xFF104B28)), // Ícono a la izquierda
                    // ignore: unnecessary_null_comparison
                    hintText:
                        "Elige una hora", // Texto por defecto si no hay fecha seleccionada
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Elige una ubicación',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 13.0),
                TextField(
                  readOnly: true, // Campo de solo lectura
                  onTap: _openMap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent, // Color del borde
                        // Grosor del borde
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(
                            0xFF104B28), // Color del borde cuando está enfocado
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFF104B28)), // Ícono a la izquierda
                    // ignore: unnecessary_null_comparison
                    hintText:
                        locationName, // Texto por defecto si no hay fecha seleccionada
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 13.0),
                TextField(
                  readOnly: true, // Campo de solo lectura
                  onTap: getLocation,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors
                            .transparent, // Color del borde cuando está enfocado
                        width: 0,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.location_pin,
                        color: Color(0xFF104B28)), // Ícono a la izquierda
                    // ignore: unnecessary_null_comparison
                    hintText:
                        "Usar mi ubicación actual", // Texto por defecto si no hay fecha seleccionada
                    // hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 13.0),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF104B28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Enviar solicitud',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          currentIndex: 3,
        ));
  }
}
