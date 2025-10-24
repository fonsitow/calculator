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
                maxHeight: alto * 0.6,
                minHeight: alto * 0.4,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Historial de cálculos',
                    style: TextStyle(
                      fontSize: ancho * 0.04,
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
                              style: TextStyle(fontSize: ancho * 0.05),
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
                  const SizedBox(height: 4),
                  Row(
                    spacing: 0.5,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            seleccionados = Set.from(
                              List.generate(historial.length, (i) => i),
                            );
                          });
                        },
                        child: const Text('seleccionar todo'),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            seleccionados.clear();
                          });
                        },
                        child: const Text('desceleccionar'),
                      ),
                      TextButton(
                        onPressed: () {
                          eliminarSeleccionados();
                          Navigator.pop(context);
                        },
                        child: const Text('eliminar'),
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
    double verticalPadding = alto * (alto >= 64 ? 0.08 : 0.06);
    verticalPadding = verticalPadding.clamp(
      8.0,
      64.0,
    ); // limita entre 8 y 32 pixeles

    final List<Map<String, dynamic>> botones = [
      {
        'label': 'AC',
        'style': StylesButton().opcion,
        'textStyle': StylesButton.opcionText,
        'onPressed': () => setState(() {
          _input.clear();
        }),
      },
      {
        'label': '+/-',
        'style': StylesButton().opcion,
        'textStyle': StylesButton.opcionText,
        'onPressed': () {
          double? valor = double.tryParse(_input.text);
          setState(() {
            if (valor != null) {
              valor = -valor!;
              _input.text = valor.toString();
            } else {
              errorFunction();
            }
          });
        },
      },
      {
        'icon': Icon(Icons.percent),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          double? valor = double.tryParse(_input.text);
          setState(() {
            if (valor != null) {
              double porcentaje = valor / 100;
              _input.text = porcentaje.toString();
            } else {
              errorFunction();
            }
          });
        },
      },
      {
        'icon': Icon(CupertinoIcons.divide),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          setState(() {
            try {
              if (_input.text.characters.isEmpty ||
                  _input.text.characters.last != '÷') {
                _input.text += '÷';
              }
            } catch (e) {
              errorFunction();
            }
          });
        },
      },
      {
        'label': '1',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '1';
        }),
      },
      {
        'label': '2',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '2';
        }),
      },
      {
        'label': '3',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '3';
        }),
      },
      {
        'icon': Icon(Icons.add),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
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
      },
      {
        'label': '4',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '4';
        }),
      },
      {
        'label': '5',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '5';
        }),
      },
      {
        'label': '6',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '6';
        }),
      },
      {
        'icon': Icon(Icons.remove),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          setState(() {
            try {
              if (_input.text.characters.last != '-') {
                _input.text += '-';
              } else {}
            } catch (e) {
              errorFunction();
            }
          });
        },
      },
      {
        'label': '7',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '7';
        }),
      },
      {
        'label': '8',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '8';
        }),
      },
      {
        'label': '9',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '9';
        }),
      },
      {
        'icon': Icon(CupertinoIcons.multiply),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          setState(() {
            try {
              if (_input.text.characters.last != '×') {
                _input.text += '×';
              } else {}
            } catch (e) {
              errorFunction();
            }
          });
        },
      },
      {
        'label': '.',
        'style': StylesButton().secundary,
        'textStyle': StylesButton.opcionText,
        'onPressed': () => setState(() {
          _input.text += '.';
        }),
      },
      {
        'label': '0',
        'style': StylesButton().primary,
        'textStyle': StylesButton.primaryText,
        'onPressed': () => setState(() {
          _input.text += '0';
        }),
      },
      {
        'icon': Icon(Icons.backspace_outlined),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          setState(() {
            if (_input.text.isNotEmpty) {
              _input.text = _input.text.substring(0, _input.text.length - 1);
              // Mueve el cursor al final después de borrar
              _input.selection = TextSelection.fromPosition(
                TextPosition(offset: _input.text.length),
              );
            }
          });
        },
      },
      {
        'icon': Icon(CupertinoIcons.equal),
        'color': const Color.fromARGB(255, 151, 42, 235),
        'style': StylesButton().icon,
        'onPressed': () {
          try {
            final expresion = _input.text
                .replaceAll('×', '*')
                .replaceAll('÷', '/')
                .replaceAll('−', '-');

            final parser = Parser();
            final exp = parser.parse(expresion);
            final cm = ContextModel();
            double result = exp.evaluate(EvaluationType.REAL, cm);

            String resultado = result.toString();
            if (resultado.endsWith('.0')) {
              resultado = resultado.substring(0, resultado.length - 2);
            }

            setState(() {
              _input.text = resultado;
              _input.selection = TextSelection.fromPosition(
                TextPosition(offset: _input.text.length),
              );
              final entrada = '$expresion = $resultado';
              historial.insert(0, entrada);
              guardarHistorial(historial);
            });
          } catch (e) {
            errorFunction();
          }
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(172, 35, 35, 35),
      drawer: MenuLateral(title: 'Calculadora simple'),
      appBar: appBarCustom(
        'Calculadora simple',
        const Icon(Icons.calculate_outlined),
        const Color.fromARGB(57, 146, 146, 146),
        mostrarHistorialModal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Visor de resultados que se adapta al contenido
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.bottomRight,
                color: const Color.fromARGB(57, 146, 146, 146),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _mostrarError
                        ? 'error'
                        : _input.text.isEmpty
                        ? '0'
                        : _input.text,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.11,
                      color: _mostrarError
                          ? const Color.fromARGB(133, 244, 67, 54)
                          : const Color.fromARGB(138, 18, 18, 18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Panel de botones que ocupa el resto del espacio
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = 4;
                    final spacing = 12.0;
                    final padding = 8.0;
                    final rowCount = (botones.length / crossAxisCount).ceil();

                    final buttonWidth =
                        (constraints.maxWidth -
                            (spacing * (crossAxisCount - 1)) -
                            (padding * 2)) /
                        crossAxisCount;
                    final buttonHeight =
                        (constraints.maxHeight -
                            (spacing * (rowCount - 1)) -
                            (padding * 2)) /
                        rowCount;
                    final childAspectRatio = buttonWidth / buttonHeight;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                      padding: EdgeInsets.all(padding),
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: childAspectRatio,
                      children: botones.map(buildButton).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
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

  Widget buildButton(Map<String, dynamic> boton) {
  final ButtonStyle? buttonStyle = boton['style'] as ButtonStyle?;
  final Color? color = boton['color'] as Color?;
  final VoidCallback? onPressed = boton['onPressed'] as VoidCallback?;

  final Widget child = boton.containsKey('icon')
      ? IconTheme(
          data: IconThemeData(size: 24, color: color),
          child: boton['icon'] as Widget,
        )
      : Text(
          boton['label'] ?? '',
          style: (boton['textStyle'] as TextStyle?)?.copyWith(color: color) ??
              TextStyle(color: color),
        );

  return TextButton(
    onPressed: onPressed,
    style: buttonStyle,
    child: child,
  );
  }