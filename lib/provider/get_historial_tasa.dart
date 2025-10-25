import 'dart:convert';
import 'package:calculator/models/tasa_history.dart';
import 'package:http/http.dart' as http;

Future<List<TasaHistory>> getHistory() async {
  final response = await http.get(
    Uri.parse('https://api.dolarvzla.com/public/exchange-rate/list'),
  );

  List<TasaHistory> historial = [];

  if (response.statusCode == 200) {
    final datosJson = jsonDecode(response.body);
    final rate = datosJson['rates'];

    for (var item in rate) {
      historial.add(
        TasaHistory(
          date: item['date'].toString(),
          usd: item['usd'],
          eur: item['eur'],
        ),
      );
    }

    return historial;
  } else {
    return Future.error('ocurrio un error inesperado');
  }
}
