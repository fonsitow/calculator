import 'package:calculator/screens/cience_calculator.dart';
import 'package:calculator/screens/home.dart';
import 'package:calculator/screens/tasa_calculator.dart';
import 'package:flutter/material.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key, required this.title});
  final String title;
  


  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(172, 35, 35, 35),
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsetsGeometry.all(0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(172, 50, 50, 50),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calculate_outlined, color: Colors.white),
            title: Text(
              'Calculadora Simple',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Home(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate, color: Colors.white),
            title: Text(
              'Calculadora Cientifica',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CienceCalculator(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.money, color: Colors.white),
            title: Text(
              'Calculadora De Cambio',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TasaCalculator(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  transitionDuration: Duration(milliseconds: 500),
                ));
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('Acerca de', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Acción al tocar "Acerca de"
            },
          ),
        ],
      ),
    );
  }
}
