import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Índice de la pestaña seleccionada

  const CustomBottomNavBar({super.key, required this.currentIndex});

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
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/learn');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/scan');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/bag');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/profile');
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
            icon: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF104B28), // Fondo verde
                ),
                Image.asset(
                  'assets/barcode_scanner_24dp.png', // Ruta del ícono
                  width: 30.0,
                  height: 30.0,
                  color: Colors.white, // Ícono blanco
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.shopping_bag
                  : Icons.shopping_bag_outlined, // Relleno si es seleccionado
              size: 30,
            ),
            label: 'Bolsa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 4
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
