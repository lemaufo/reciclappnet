import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false; // Evita retroceder con el botón de atrás del dispositivo
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0xFF000000),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          ),
          toolbarHeight: 78.0,
          title: const Text('Ayuda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Agrega un margen alrededor
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Aviso',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Reciclapp valora tu privacidad y se compromete a proteger tus datos personales. Esta aplicación recopila información como nombre, dirección de correo electrónico, ubicación y detalles de los residuos escaneados para mejorar tu experiencia y facilitar el reciclaje. Tus datos son utilizados exclusivamente para personalizar tu experiencia, coordinar recolecciones y ofrecerte información sobre puntos de reciclaje cercanos.',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Términos y condiciones',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20), // Espacio entre los párrafos
              Text(
                'Al utilizar Reciclapp, aceptas nuestros términos y condiciones. Esta aplicación está diseñada para ayudarte a identificar y gestionar residuos reciclables de manera eficiente. Reciclapp no garantiza disponibilidad constante de sus servicios y no se responsabiliza por interrupciones o errores.',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20), // Espacio entre los párrafos
              Text(
                'El uso de la aplicación implica la aceptación de nuestras políticas de privacidad y el acuerdo de que tus datos sean tratados de acuerdo con las mismas. Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento, notificándote a través de la app o nuestro sitio web.',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20), // Espacio entre los párrafos
              Text(
                'Para consultas o preocupaciones sobre cómo manejamos tus datos, contáctanos a través de nuestros canales de soporte. Gracias por unirte a nuestra iniciativa de reciclaje sostenible.',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
