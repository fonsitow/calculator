import 'dart:convert';
import 'package:calculator/components/appbar.dart';
import 'package:calculator/components/drawer.dart';
import 'package:calculator/models/tasa.dart';
import 'package:calculator/models/tasa_previous.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TasaCalculator extends StatefulWidget {
  const TasaCalculator({super.key});

  @override
  State<TasaCalculator> createState() => _TasaCalculatorState();
}

class _TasaCalculatorState extends State<TasaCalculator> {
  final NumberFormat formatter = NumberFormat.decimalPattern();
  String monedaSeleccionada = 'USD';
  String? fechaActualizacion;
  ModelTasa? tasaActual;
  ModelPreviousTasa? tasaPrevious;
  String? fechaPrevia;
  bool cargandoTasa = false;
  bool bloqueado = false;

  final usdController = TextEditingController();
  final vesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarTasaDelDia();
  }

  // ! CURRENT TASA / TASA DEL DIA
  Future cargarTasaDelDia() async {
    setState(() => cargandoTasa = true);

    try {
      final response = await http.get(
        Uri.parse('https://api.dolarvzla.com/public/exchange-rate'),
      );

      if (response.statusCode == 200) {
        final datosJson = jsonDecode(response.body);
        final current = datosJson['current'];
        final previous = datosJson['previous'];

        if (previous != null) {
          setState(() {
            tasaPrevious = ModelPreviousTasa.fromMap(previous);
            fechaPrevia = previous['date'];
          });
        }

        if (current != null) {
          setState(() {
            tasaActual = ModelTasa.fromMap(current);
            fechaActualizacion = current['date'];
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error al cargar tasa: $e');
    } finally {
      setState(() => cargandoTasa = false);
    }
  }

  double get tasaSeleccionada {
    if (tasaActual == null) return 0;
    return monedaSeleccionada == 'USD' ? tasaActual!.usd : tasaActual!.eur;
  }

  void recalcularDesdeUSD(String valor) {
    if (bloqueado || tasaActual == null) return;
    final usd = double.tryParse(valor.replaceAll(',', ''));
    if (usd != null) {
      bloqueado = true;
      final convertido = usd * tasaSeleccionada;
      vesController.text = formatter.format(convertido);
      bloqueado = false;
    }

    if (usdController.text.isEmpty) {
      vesController.clear();
    }
  }

  void recalcularDesdeVES(String valor) {
    if (bloqueado || tasaActual == null) return;
    final ves = double.tryParse(valor.replaceAll(',', ''));
    if (ves != null) {
      bloqueado = true;
      final convertido = ves / tasaSeleccionada;
      usdController.text = formatter.format(convertido);
      bloqueado = false;
    }

    if (vesController.text.isEmpty) {
      usdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(172, 35, 35, 35),
      appBar: appBarCustom(
        'Calculadora Cambio',
        Icon(Icons.monetization_on),
        Colors.transparent,
        (){}
      ),
      drawer: MenuLateral(title: 'Calculadora De Cambio'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ? LISTA DE MONEDAS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 50, 50, 50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(147, 135, 255, 129),
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: monedaSeleccionada,
                  isExpanded: true,
                  dropdownColor: const Color.fromARGB(221, 40, 40, 40),
                  icon: Icon(
                    monedaSeleccionada == 'USD'
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: const Color.fromARGB(147, 135, 255, 129),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  items: ['USD', 'EUR'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(
                            value == 'USD' ? Icons.attach_money : Icons.euro,
                            color: const Color.fromARGB(147, 135, 255, 129),
                          ),
                          const SizedBox(width: 8),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      monedaSeleccionada = value!;
                      recalcularDesdeUSD(usdController.text);
                    });
                  },
                ),
              ),
            ),

            // * Carta de tasa actual
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: const Color.fromARGB(147, 135, 255, 129),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tasaSeleccionada > 0
                          ? 'Tasa actual: ${tasaSeleccionada.toStringAsFixed(2)} Bs = 1 $monedaSeleccionada'
                          : 'Tasa no cargada aún',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BotonRecargaTasa(onRecargar: cargarTasaDelDia),
                ],
              ),
            ),
            if (fechaActualizacion != null)
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Container(
                  alignment: Alignment(-1, -2),
                  child: Text(
                    'Actualizado: $fechaActualizacion',
                    style: TextStyle(
                      color: const Color.fromARGB(147, 135, 255, 129),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16),

            // * RECUADROS DE CALCULO
            TextField(
              showCursor: false,
              autocorrect: true,
              inputFormatters: [Formatter()],
              style: TextStyle(color: Colors.white),
              controller: usdController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: monedaSeleccionada == 'USD' ? '\$  ' : '€  ',
                prefixStyle: TextStyle(
                  color: Color.fromARGB(147, 135, 255, 129),
                  fontSize: 16,
                ),
                hint: Text(
                  '0',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                labelText: 'USD/EUR',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green
                  )
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color.fromARGB(118, 255, 255, 255),
                  ),
                  tooltip: 'Copiar al portapapeles',
                  onPressed: () {
                    final texto = usdController.text;
                    if (texto.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: texto));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copiado al portapapeles'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ),
              onChanged: (valor) {
                final limpio = valor.replaceAll(',', '');
                recalcularDesdeUSD(limpio);
              },
            ),

            SizedBox(height: 12),
            TextField(
              showCursor: false,
              autocorrect: true,
              inputFormatters: [Formatter()],
              style: TextStyle(color: Colors.white),
              controller: vesController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: 'Bs  ',
                prefixStyle: TextStyle(
                  color: Color.fromARGB(147, 135, 255, 129),
                  fontSize: 16,
                ),
                hint: Text(
                  '0',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                labelText: 'Bs',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green
                  )
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Color.fromARGB(118, 255, 255, 255),
                  ),
                  tooltip: 'Copiar al portapapeles',
                  onPressed: () {
                    final texto = vesController.text;
                    if (texto.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: texto));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copiado al portapapeles'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ),
              onChanged: (valor) {
                final limpio = valor.replaceAll(',', '');
                recalcularDesdeVES(limpio);
              },
            ),

            //Precios y fechas previas
            
          ],
        ),
      ),
    );
  }
}

class BotonRecargaTasa extends StatefulWidget {
  final Future<void> Function() onRecargar;

  const BotonRecargaTasa({super.key, required this.onRecargar});

  @override
  State<BotonRecargaTasa> createState() => _BotonRecargaTasaState();
}

class _BotonRecargaTasaState extends State<BotonRecargaTasa> {
  bool cargando = false;

  void ejecutarRecarga() async {
    setState(() => cargando = true);
    await widget.onRecargar();
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return cargando
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color.fromARGB(176, 255, 255, 255),
            ),
          )
        : IconButton(
            onPressed: ejecutarRecarga,
            icon: const Icon(
              Icons.refresh,
              color: Color.fromARGB(176, 255, 255, 255),
              size: 24,
            ),
            tooltip: 'Recargar tasa',
          );
  }
}

class Formatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,##0.##", "en_US");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(',', '');

    // Permitir que el usuario escriba solo "." o termine en "."
    if (text.isEmpty || text == '.' || text.endsWith('.')) {
      return newValue;
    }

    final number = double.tryParse(text);
    if (number == null) return oldValue;

    final newText = formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
