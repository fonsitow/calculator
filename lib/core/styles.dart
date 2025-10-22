import 'package:flutter/material.dart';

class StylesButton {

  final ButtonStyle primary = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(const Color.fromARGB(225, 255, 255, 255)),
    textStyle: WidgetStatePropertyAll(TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w500, fontSize: 18)),
    overlayColor: WidgetStatePropertyAll(
      const Color.fromARGB(150, 68, 137, 255),
    ),
    elevation: WidgetStatePropertyAll(3),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    ),
  );

  final ButtonStyle secundary = ButtonStyle(
    textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
    overlayColor: WidgetStatePropertyAll(
      const Color.fromARGB(149, 68, 255, 118),
    ),
    elevation: WidgetStatePropertyAll(3),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    ),
    iconSize: WidgetStatePropertyAll(24),
  );

  final ButtonStyle icon = ButtonStyle(
    textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
    overlayColor: WidgetStatePropertyAll(
      const Color.fromARGB(110, 99, 68, 255),
    ),
    elevation: WidgetStatePropertyAll(3),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ),
    iconSize: WidgetStatePropertyAll(24),
  );

  
  final ButtonStyle opcion = ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    ),
    overlayColor: WidgetStatePropertyAll(
      const Color.fromARGB(123, 68, 255, 118),
    ),
    elevation: WidgetStatePropertyAll(3),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
    iconSize: WidgetStatePropertyAll(24),
  );
}
