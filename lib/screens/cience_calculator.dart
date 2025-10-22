import 'package:calculator/components/appbar.dart';
import 'package:calculator/components/drawer.dart';
import 'package:flutter/material.dart';

class CienceCalculator extends StatefulWidget {
  const CienceCalculator({super.key});

  @override
  State<CienceCalculator> createState() => _CienceCalculatorState();
}

class _CienceCalculatorState extends State<CienceCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(172, 35, 35, 35),
      drawer: MenuLateral(title: 'Calculadora Cientifica'),
      appBar: appBarCustom('Calculadora Cientifica', Icon(Icons.calculate_rounded), Colors.transparent, (){}),
      body: Center(
        child: Text('Aquí va la calculadora científica'),
      ),
    );
  }
}