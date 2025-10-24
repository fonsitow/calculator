import 'package:flutter/material.dart';

class ModalHistory extends StatefulWidget {
  const ModalHistory({super.key});

  @override
  State<ModalHistory> createState() => _ModalHistoryState();
}

class _ModalHistoryState extends State<ModalHistory> {
  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: alto * 0.6,
        minHeight: alto * 0.4,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: const [
          Text('Historial de tasas'),
        ],
      ),
    );
  }
}