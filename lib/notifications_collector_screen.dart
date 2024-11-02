import 'package:flutter/material.dart';

class NotificationsCollectorScreen extends StatelessWidget {
  const NotificationsCollectorScreen({super.key});

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
                  Navigator.pushReplacementNamed(context, '/homecollector');
                },
              ),
            ),
            toolbarHeight: 78.0,
            title: const Text('Notificaciones',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Container()),
    );
  }
}
