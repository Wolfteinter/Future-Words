import 'package:sqflite/sqflite.dart';

class Group {
  int? id;
  final String name;

  Group({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return "{" + this.id.toString() + " , " + this.name + "}";
  }
}
