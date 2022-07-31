import 'package:translator/translator.dart';
import 'dart:async' show Future;

class Utils {
  static final translator = GoogleTranslator();

  static Future<String> translate(
      String input, String from, String lang) async {
    var translation =
        await translator.translate(input, from: from, to: lang).catchError((e) {
      return "error";
    });
    return translation.text;
  }
}
