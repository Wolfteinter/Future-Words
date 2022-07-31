import 'package:translator/translator.dart';
import 'package:sqflite/sqflite.dart';

class Entry {
  int? id;
  String value;
  String translation;
  final int sourceLangId;
  final int translationLangId;
  final int groupId;
  int? count;

  Entry(
      {this.id,
      required this.value,
      required this.translation,
      required this.sourceLangId,
      required this.translationLangId,
      required this.groupId,
      required this.count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'translation': translation,
      'sourceLangId': sourceLangId,
      'translationLangId': translationLangId,
      'groupId': groupId,
      'count': count
    };
  }
}
