import 'package:flutter/material.dart';

AppBar appBarCustom(String title, Icon icono, Color color, VoidCallback historial) {
  return AppBar(
    title: Text(title),
    actions: [
      icono,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(onPressed: historial, icon: Icon(Icons.history)),
      ),
    ],
    backgroundColor: color,
    foregroundColor: Colors.white,
  );
}
