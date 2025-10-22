import 'package:calculator/components/appbar.dart';
import 'package:calculator/components/drawer.dart';
import 'package:calculator/core/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    cargarHistorial();
  }

  Future<void> cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      historial = prefs.getStringList('historial') ?? [];
    });
  }

  void eliminarSeleccionados() {
    final indices = seleccionados.toList()..sort((a, b) => b.compareTo(a));
    for (final i in indices) {
      historial.removeAt(i);
    }
    seleccionados.clear();
    guardarHistorial(historial);
    setState(() {});
  }

  List<String> historial = [];
  Set<int> seleccionados = {};

  Future<void> guardarHistorial(List<String> historial) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('historial', historial);
  }

  void mostrarHistorialModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final alto = MediaQuery.of(context).size.height;
        final ancho = MediaQuery.of(context).size.width;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: alto * 0.7,
                minHeight: alto * 0.4,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Historial de cálculos',
                    style: TextStyle(
                      fontSize: ancho * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (historial.isEmpty)
                    const Text('No hay cálculos guardados.'),
                  if (historial.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: historial.length,
                        itemBuilder: (context, index) {
                          final item = historial[index];
                          final seleccionado = seleccionados.contains(index);

                          return ListTile(
                            leading: Checkbox(
                              value: seleccionado,
                              onChanged: (value) {
                                setModalState(() {
                                  if (value == true) {
                                    seleccionados.add(index);
                                  } else {
                                    seleccionados.remove(index);
                                  }
                                });
                              },
                            ),
                            title: Text(
                              item,
                              style: TextStyle(fontSize: ancho * 0.04),
                            ),
                            onTap: () {
                              setState(() {
                                _input.text = item.split('=').first.trim();
                                _input.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _input.text.length),
                                );
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            seleccionados = Set.from(
                              List.generate(historial.length, (i) => i),
                            );
                          });
                        },
                        child: const Text('Seleccionar todos'),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            seleccionados.clear();
                          });
                        },
                        child: const Text('Deseleccionar'),
                      ),
                      TextButton(
                        onPressed: () {
                          eliminarSeleccionados();
                          Navigator.pop(context);
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Controllers
  final TextEditingController _input = TextEditingController(text: '');
  bool _mostrarError = false;

  @override
  Widget build(BuildContext context) {
    // Media Query
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(172, 35, 35, 35),
      drawer: MenuLateral(title: 'Calculadora simple'),
      appBar: appBarCustom(
        'Calculadora simple',
        Icon(Icons.calculate_outlined),
        const Color.fromARGB(57, 146, 146, 146),
        mostrarHistorialModal,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TextField(
                readOnly: true,
                controller: _input,
                keyboardType: TextInputType.none,
                showCursor: false,
                style: TextStyle(
                  fontSize: ancho * 0.09,
                  color: const Color.fromARGB(139, 21, 21, 21),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: alto * 0.05,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(57, 146, 146, 146),
                  hintText: _mostrarError ? 'error' : '0',
                  hintStyle: TextStyle(
                    color: _mostrarError
                        ? const Color.fromARGB(133, 244, 67, 54)
                        : const Color.fromARGB(100, 0, 0, 0),
                    fontSize: ancho * 0.09,
                  ),
                  counterText: '',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                padding: EdgeInsets.all(16),
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.clear();
                      });
                    },
                    icon: Text('AC'),
                    color: const Color.fromARGB(255, 106, 255, 146),
                    style: StylesButton().opcion,
                  ),

                  IconButton.outlined(
                    color: const Color.fromARGB(255, 106, 255, 146),
                    onPressed: () {
                      double? valor = double.tryParse(_input.text);
                      if (valor != null) {
                        valor = -valor;
                        _input.text = valor.toString();
                      } else {
                        errorFunction();
                      }
                    },
                    icon: Text('+/-'),
                    style: StylesButton().opcion,
                  ),

                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      double? valor = double.tryParse(_input.text);
                      if (valor != null) {
                        double porcentaje = valor / 100;
                        _input.text = porcentaje.toString();
                      } else {
                        errorFunction();
                      }
                    },
                    icon: Icon(Icons.percent),
                    style: StylesButton().icon,
                  ),

                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      try {
                        if (_input.text.characters.last != '÷') {
                          _input.text += '÷';
                        } else {}
                      } catch (e) {
                        errorFunction();
                      }
                    },
                    icon: Icon(CupertinoIcons.divide),
                    style: StylesButton().icon,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '1';
                      });
                    },
                    icon: Text('1'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '2';
                      });
                    },
                    icon: Text('2'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '3';
                      });
                    },
                    icon: Text('3'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      setState(() {
                        try {
                          if (_input.text.characters.last != '+') {
                            _input.text += '+';
                          } else {}
                        } catch (e) {
                          errorFunction();
                        }
                      });
                    },
                    icon: Icon(Icons.add),
                    style: StylesButton().icon,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '4';
                      });
                    },
                    icon: Text('4'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '5';
                      });
                    },
                    icon: Text('5'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '6';
                      });
                    },
                    icon: Text('6'),
                    style: StylesButton().primary,
                  ),
                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      try {
                        if (_input.text.characters.last != '-') {
                          _input.text += '-';
                        } else {}
                      } catch (e) {
                        errorFunction();
                      }
                    },
                    icon: Icon(Icons.remove),
                    style: StylesButton().icon,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '7';
                      });
                    },
                    icon: Text('7'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '8';
                      });
                    },
                    icon: Text('8'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '9';
                      });
                    },
                    icon: Text('9'),
                    style: StylesButton().primary,
                  ),

                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      try {
                        if (_input.text.characters.last != '×') {
                          _input.text += '×';
                        }
                      } catch (e) {
                        errorFunction();
                      }
                    },
                    icon: Icon(CupertinoIcons.multiply),
                    style: StylesButton().icon,
                  ),
                  IconButton.outlined(
                    color: const Color.fromARGB(255, 106, 255, 146),
                    onPressed: () {
                      setState(() {
                        _input.text += '.';
                      });
                    },
                    icon: Text(
                      '.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: StylesButton().secundary,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _input.text += '0';
                      });
                    },
                    icon: Text('0'),
                    style: StylesButton().primary,
                  ),
                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      setState(() {
                        if (_input.text.isNotEmpty) {
                          _input.text = _input.text.substring(
                            0,
                            _input.text.length - 1,
                          );
                          // Mueve el cursor al final después de borrar
                          _input.selection = TextSelection.fromPosition(
                            TextPosition(offset: _input.text.length),
                          );
                        }
                      });
                    },
                    icon: Icon(Icons.backspace),
                    style: StylesButton().icon,
                  ),
                  IconButton.outlined(
                    color: const Color.fromARGB(255, 151, 42, 235),
                    onPressed: () {
                      setState(() {
                        void guardarEnHistorial(
                          String expresion,
                          String resultado,
                        ) {
                          final entrada = '$expresion = $resultado';
                          setState(() {
                            historial.insert(
                              0,
                              entrada,
                            ); // lo más reciente arriba
                          });
                          guardarHistorial(historial);
                        }

                        try {
                          String traducirParaEvaluar(String expresionVisual) {
                            return expresionVisual
                                .replaceAll('×', '*')
                                .replaceAll('÷', '/')
                                .replaceAll('−', '-')
                                .replaceAll('+', '+');
                          }

                          String expresion = traducirParaEvaluar(_input.text);

                          // ignore: deprecated_member_use
                          Parser parser = Parser();
                          Expression exp = parser.parse(expresion);
                          ContextModel cm = ContextModel();
                          double result = exp.evaluate(EvaluationType.REAL, cm);
                          _input.text = result.toString();

                          if (_input.text.endsWith('.0')) {
                            _input.text = _input.text.substring(
                              0,
                              _input.text.length - 2,
                            );

                            guardarEnHistorial(expresion, _input.text);
                          }
                        } catch (e) {
                          errorFunction();
                        }
                      });
                    },
                    icon: Icon(CupertinoIcons.equal),
                    style: StylesButton().icon,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void errorFunction() {
    setState(() {
      _mostrarError = true;
      _input.text = ''; // vacía el campo para que solo se vea el hint
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _mostrarError = false;
        _input.clear(); // reinicia el campo
      });
    });
  }
}
