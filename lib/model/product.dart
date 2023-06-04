import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Product extends Equatable {
  final String nome, descrizione, type;
  final List<double> prezzi;

  const Product(
      {required this.nome,
      required this.descrizione,
      required this.type,
      required this.prezzi});

  Product.fromJson(Map<String, dynamic> json)
      : nome = json["nome"] as String,
        descrizione = (json["descrizione"] ?? "") as String,
        type = json["type"] as String,
        prezzi = _listFromDynamic(json["prezzi"] as List<dynamic>);

  static List<double> _listFromDynamic(List<dynamic> list) {
    List<double> res = [];
    for (dynamic d in list) {
      res.add((d as num) + 0.0);
    }
    return res;
  }

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "descrizione": descrizione,
        "type": type,
        "prezzi": prezzi
      };

  Product copyWith(
          {String? nome,
          String? descrizione,
          String? type,
          List<double>? prezzi}) =>
      Product(
          nome: nome ?? this.nome,
          descrizione: descrizione ?? this.descrizione,
          type: type ?? this.type,
          prezzi: prezzi ?? this.prezzi);
  @override
  List<Object?> get props => [nome, descrizione, prezzi, type];

  String get image => "$type/$nome.jpg";
}
