import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calculator/models/tasa_history.dart';
import 'package:calculator/provider/get_historial_tasa.dart';

class ModalHistory extends StatefulWidget {
  const ModalHistory({super.key});

  @override
  State<ModalHistory> createState() => _ModalHistoryState();
}

class _ModalHistoryState extends State<ModalHistory> {
  late Future<List<TasaHistory>> futureHistorial;
  List<TasaHistory> historial = [];
  List<TasaHistory> resultados = [];

  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  String tipoMonedaSeleccionada = 'eur';
  String? yearFiltrado;

  @override
  void initState() {
    super.initState();
    futureHistorial = getHistory();
  }

  void buscarPorMonto(String montoTexto) {
    final monto = double.tryParse(montoTexto.replaceAll(',', '.'));
    if (monto == null) {
      setState(() => resultados = []);
      return;
    }

    final fuente = yearFiltrado != null
        ? historial.where((item) => item.date.startsWith(yearFiltrado!)).toList()
        : historial;

    final encontrados = fuente
        .map((item) {
          final valor = tipoMonedaSeleccionada == 'eur' ? item.eur : item.usd;
          final diferencia = (valor - monto).abs();
          return {'item': item, 'diferencia': diferencia};
        })
        .toList()
      ..sort((a, b) => (a['diferencia'] as double).compareTo(b['diferencia'] as double));

    final filtrados = encontrados.map((e) => e['item'] as TasaHistory).toList();

    setState(() => resultados = filtrados.take(5).toList());
  }

  void buscarPorFecha(String texto) {
    final year = texto.trim();
    if (year.length != 4 || int.tryParse(year) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un año válido (ej. 2023)')),
      );
      return;
    }

    final encontrados = historial
        .where((item) => item.date.startsWith(year))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (encontrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontraron tasas para el año $year')),
      );
    }

    setState(() {
      resultados = encontrados;
      yearFiltrado = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Historial de tasas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: fechaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Buscar por año (ej. 2025)',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: buscarPorFecha,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: montoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Buscar por monto',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: buscarPorMonto,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color.fromARGB(255, 190, 190, 190),
                        borderRadius: BorderRadius.circular(16),
                        value: tipoMonedaSeleccionada,
                        items: const [
                          DropdownMenuItem(value: 'eur', child: Text('EUR')),
                          DropdownMenuItem(value: 'usd', child: Text('USD')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => tipoMonedaSeleccionada = value);
                            buscarPorMonto(montoController.text);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<TasaHistory>>(
                future: futureHistorial,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return const Expanded(child: Center(child: Text('Error al cargar el historial.')));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Expanded(child: Center(child: Text('No hay datos disponibles.')));
                  }

                  historial = snapshot.data!;
                  final mostrar = resultados.isNotEmpty
                      ? [...resultados, ...historial.where((e) => !resultados.contains(e))]
                      : historial;

                  return Expanded(
                    child: ListView.separated(
                      itemCount: mostrar.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final item = mostrar[index];
                        return Card(
                          elevation: 2,
                          color: resultados.contains(item)
                              ? Colors.yellow.shade100
                              : Colors.white,
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(item.date))),
                            subtitle: Text(
                              'USD: ${item.usd.toStringAsFixed(2)} Bs   |   EUR: ${item.eur.toStringAsFixed(2)} Bs',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
