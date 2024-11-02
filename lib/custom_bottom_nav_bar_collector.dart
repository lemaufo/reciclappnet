import 'package:flutter/material.dart';

class CustomBottomNavBarCollector extends StatelessWidget {
  final int currentIndex; // Índice de la pestaña seleccionada

  const CustomBottomNavBarCollector({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex, // Índice del ítem seleccionado
        onTap: (index) {
          if (index != currentIndex) {
            // Verifica si el índice seleccionado no es el actual
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/homecollector');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/learncollector');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/requests');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profilecollector');
                break;
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0
                  ? Icons.home_filled
                  : Icons.home_filled, // Relleno si es seleccionado
              size: 30,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.menu_book
                  : Icons.menu_book_outlined, // Relleno si es seleccionado
              size: 30,
            ),
            label: 'Aprende',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2
                  ? Icons.newspaper_rounded
                  : Icons.newspaper_outlined, // Relleno si es seleccionado
              size: 30,
            ),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.person
                  : Icons.person_outline, // Relleno si es seleccionado
              size: 30,
            ),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: const Color(0xFF104B28), // Verde para seleccionado
        unselectedItemColor: Colors.black, // Negro para no seleccionado
      ),
    );
  }
}
