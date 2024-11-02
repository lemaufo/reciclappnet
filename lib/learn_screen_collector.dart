import 'package:flutter/material.dart';
import 'package:reciclapp/custom_bottom_nav_bar_collector.dart';

class LearnCollectorScreen extends StatelessWidget {
  const LearnCollectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context)
              .scaffoldBackgroundColor, // Fondo transparente para que combine con la pantalla
          elevation: 0, // Sin sombra
          toolbarHeight: 78.0,
          title: const Text('Aprende',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(),
        bottomNavigationBar:
            const CustomBottomNavBarCollector(currentIndex: 1));
  }
}
