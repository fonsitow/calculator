import 'dart:convert';

class ModelPercentaje {
  final double usd;
  final double eur;

  ModelPercentaje({required this.usd, required this.eur});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'usd': usd,
      'eur': eur,
    };
  }

  factory ModelPercentaje.fromMap(Map<String, dynamic> map) {
    return ModelPercentaje(
      usd: (map['usd'] as num).toDouble(),
      eur: (map['eur'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelPercentaje.fromJson(String source) => ModelPercentaje.fromMap(json.decode(source) as Map<String, dynamic>);

}
