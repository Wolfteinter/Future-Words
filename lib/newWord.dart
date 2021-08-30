import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'itemList.dart';
import 'langIcon.dart';
import 'utils.dart';

class NewWord extends StatefulWidget {
  final Function addWord;
  const NewWord(this.addWord, {Key? key}) : super(key: key);

  @override
  _NewWordState createState() => _NewWordState();
}

class _NewWordState extends State<NewWord> {
  TextEditingController wordController = new TextEditingController();
  TextEditingController translateController = new TextEditingController();
  List<LangIcon> dropDownItems = [
    LangIcon("icons/flags/png/us.png", "en"),
    LangIcon("icons/flags/png/de.png", "de"),
    LangIcon("icons/flags/png/mx.png", "es")
  ];
  LangIcon wordIcon = LangIcon("icons/flags/png/us.png", "en");
  LangIcon translationIcon = LangIcon("icons/flags/png/mx.png", "es");
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: new BoxDecoration(
                color: Colors.green,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child: Align(
                  child: Text(
                'ADD WORD',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              )),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                  autofocus: true,
                  controller: wordController,
                  maxLength: 18,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a new word',
                    suffixIcon: DropdownButton(
                        value: dropDownItems[0],
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (LangIcon? newValue) {
                          setState(() {
                            wordIcon = newValue!;
                          });
                        },
                        items: dropDownItems
                            .map<DropdownMenuItem<LangIcon>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Tab(
                                icon: Image.asset(
                              value.path,
                              package: 'country_icons',
                              width: 30.0,
                              height: 30.0,
                            )),
                          );
                        }).toList()),
                  ),
                  style: TextStyle(
                      fontSize: 20.0, height: 1.0, color: Colors.black)),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                  controller: translateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Here is the translate word',
                    suffixIcon: DropdownButton(
                        value: dropDownItems[2],
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (LangIcon? newValue) {
                          setState(() {
                            translationIcon = newValue!;
                          });
                        },
                        items: dropDownItems
                            .map<DropdownMenuItem<LangIcon>>((LangIcon value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Tab(
                                icon: Image.asset(
                              value.path,
                              package: 'country_icons',
                              width: 30.0,
                              height: 30.0,
                            )),
                          );
                        }).toList()),
                  ),
                  style: TextStyle(
                      fontSize: 20.0, height: 1.0, color: Colors.black)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Text(
                    "TRANSLATE",
                    style: TextStyle(
                      height: 1.0,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Utils.translate(wordController.text, translationIcon.simbol)
                        .then((String value) {
                      setState(() {
                        translateController.text = value;
                      });
                    });
                  },
                ),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text(
                      "SAVE WORD",
                      style: TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      widget.addWord(ItemList(
                          wordController.text,
                          this.translateController.text,
                          1,
                          wordIcon.simbol,
                          translationIcon.simbol));
                      Navigator.pop(context, 'OK');
                    }),
              ],
            ),
          ],
        )));
  }
}
