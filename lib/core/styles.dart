import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class StylesButton {
  // Colores comunes
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color greenAccent = Color.fromARGB(255, 106, 255, 146);
  static const Color greenText = Color.fromARGB(255, 84, 255, 118);

  // TextStyles reutilizables
  static const TextStyle primaryText = TextStyle(
    color: white,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static const TextStyle secundaryText = TextStyle(
    color: white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static const TextStyle opcionText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: greenAccent,
  );

  // ButtonStyles
  final ButtonStyle primary = ButtonStyle(
  foregroundColor: const WidgetStatePropertyAll(Colors.white),
  textStyle: const WidgetStatePropertyAll(TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  )),
  elevation: const WidgetStatePropertyAll(3),
  padding: const WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  ),
  overlayColor: const WidgetStatePropertyAll(Color.fromARGB(99, 51, 132, 255)), // Color al presionar
);

  final ButtonStyle secundary = ButtonStyle(
    textStyle: const WidgetStatePropertyAll(TextStyle(color: greenText)),
    elevation: const WidgetStatePropertyAll(3),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    ),
    iconSize: const WidgetStatePropertyAll(24),
    overlayColor: const WidgetStatePropertyAll(Color.fromARGB(98, 51, 255, 112)),
  );

  final ButtonStyle icon = ButtonStyle(
    textStyle: const WidgetStatePropertyAll(TextStyle(color: white)),
    elevation: const WidgetStatePropertyAll(3),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ),
    iconSize: const WidgetStatePropertyAll(24),
    overlayColor: const WidgetStatePropertyAll(Color.fromARGB(97, 163, 51, 255)),
  );

  final ButtonStyle opcion = ButtonStyle(
    foregroundColor: const WidgetStatePropertyAll(greenAccent),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
    iconSize: const WidgetStatePropertyAll(24),
    overlayColor: const WidgetStatePropertyAll(Color.fromARGB(98, 51, 255, 112)),
  );
}