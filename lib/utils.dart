import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'itemList.dart';
import 'package:translator/translator.dart';

class Utils {
  static final translator = GoogleTranslator();

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + "/data.json'";
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File(path);
  }

  static void updateFileFromList(List<ItemList> list) async {
    File file = await _localFile;
    var body = {};
    body["words"] = [];
    list.forEach((element) {
      body["words"].add({
        "word": element.word,
        "translate": element.translation,
        "count": element.count,
        "origin": element.origin,
        "dest": element.dest
      });
    });
    String encode = json.encode(body);
    file.writeAsString(encode);
  }

  static void updateFile(String data) async {
    File file = await _localFile;
    var body = {};
    body["words"] = data;
    String encode = json.encode(body);
    file.writeAsString(encode);
  }

  static Future<List<ItemList>> getListOfWords() async {
    File file = await _localFile;
    if (file.existsSync() == false) {
      //If aren't exist the file, create a new one and append a default word
      new File(file.path).create(recursive: true);
      var body = {};
      body["words"] = [];
      body["words"].add({
        "word": "hello",
        "translate": "hola",
        "count": 1,
        "origin": "en",
        "dest": "es"
      });
      //it is necessary to add try catches
      String encoded = json.encode(body);
      file.writeAsString(encoded);
    }
    String rawData = await file.readAsString();
    var data = json.decode(rawData);
    List words = data["words"];
    List<ItemList> result = [];
    words.forEach((element) {
      result.add(ItemList(element["word"], element["translate"],
          element["count"], element["origin"], element["dest"]));
    });
    return result;
  }

  static Future<String> translate(String input, String lang) async {
    var translation =
        await translator.translate(input, to: lang).catchError((e) {
      return "error";
    });
    return translation.text;
  }
}
