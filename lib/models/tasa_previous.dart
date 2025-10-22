import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ModelPreviousTasa {
  final double usd;
  final double eur;
  final String date;

  ModelPreviousTasa({required this.usd, required this.eur, required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'usd': usd, 'eur': eur, 'date': date};
  }

  factory ModelPreviousTasa.fromMap(Map<String, dynamic> map) {
    return ModelPreviousTasa(
      usd: (map['usd'] as num).toDouble(),
      eur: (map['eur'] as num).toDouble(),
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelPreviousTasa.fromJson(String source) =>
      ModelPreviousTasa.fromMap(json.decode(source) as Map<String, dynamic>);
}
