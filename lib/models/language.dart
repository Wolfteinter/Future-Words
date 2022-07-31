import 'package:future_words/sqlHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:future_words/sqlHelper.dart';

class Language {
  int? id;
  final String name;
  final String path;
  String symbol;

  Language(
      {this.id, required this.name, required this.path, required this.symbol});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'symbol': symbol,
    };
  }

  @override
  String toString() {
    return "{" + this.id.toString() + " , " + this.name + "}";
  }
}
