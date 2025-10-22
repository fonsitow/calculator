import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ModelTasa {
  final double usd;
  final double eur;
  final String date;

  ModelTasa({required this.usd, required this.eur, required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'usd': usd, 'eur': eur, 'date': date};
  }

  factory ModelTasa.fromMap(Map<String, dynamic> map) {
    return ModelTasa(
      usd: (map['usd'] as num).toDouble(),
      eur: (map['eur'] as num).toDouble(),
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelTasa.fromJson(String source) =>
      ModelTasa.fromMap(json.decode(source));
}
