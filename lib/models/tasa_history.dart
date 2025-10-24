// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TasaHistory {
  final String date;
  final double usd;
  final double eur;

  TasaHistory({required this.date, required this.usd, required this.eur});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'date': date, 'usd': usd, 'eur': eur};
  }

  factory TasaHistory.fromMap(Map<String, dynamic> map) {
    return TasaHistory(
      date: map['date'] as String,
      usd: (map['usd'] as num).toDouble(),
      eur: (map['eur'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TasaHistory.fromJson(String source) =>
      TasaHistory.fromMap(json.decode(source) as Map<String, dynamic>);
}
