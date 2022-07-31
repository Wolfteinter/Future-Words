import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_words/models/group.dart';
import 'package:future_words/models/language.dart';
import 'utils.dart';
import 'models/entry.dart';
import 'palette.dart';
import 'package:future_words/sqlHelper.dart';

class NewWord extends StatefulWidget {
  final Function addWord;
  final Function addGroup;
  final List<Language> _languages;
  List<Group> _groups;
  final DatabaseService _databaseService;

  NewWord(this.addWord, this.addGroup, this._languages, this._groups,
      this._databaseService,
      {Key? key})
      : super(key: key);

  @override
  _NewWordState createState() => _NewWordState();
}

class _NewWordState extends State<NewWord> {
  TextEditingController wordController = new TextEditingController();
  TextEditingController translateController = new TextEditingController();
  TextEditingController groupController = new TextEditingController();

  Language? wordIcon;
  Language? translationIcon;
  Group? _group;
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    wordIcon = widget._languages[0];
    translationIcon = widget._languages[2];
    _groups = widget._groups;
    _group = _groups[0];
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Add new group',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Palette.second)),
          content: TextField(
              autofocus: true,
              controller: groupController,
              maxLength: 25,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the group name')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Palette.second),
                ),
                child: Text(
                  "Add it",
                  style: TextStyle(
                    height: 1.0,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await widget.addGroup(Group(name: groupController.text));
                  var aux = await widget._databaseService.groups();
                  groupController.text = "";
                  setState(() {
                    _groups = aux;
                    _group = _groups[0];
                  });
                  Navigator.pop(context, 'OK');
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
        height: MediaQuery.of(context).size.height * 0.87,
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
                color: Palette.kToDark,
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
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
                        ),
                        child: Text(
                          "ADD GROUP",
                          style: TextStyle(
                            height: 1.0,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          _showDialog();
                        }),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),

                    // dropdown below..
                    child: DropdownButton<Group>(
                      isExpanded: true,
                      value: _group == null
                          ? _group
                          : _groups.where((i) => i.id == _group?.id).first,
                      onChanged: (Group? newValue) {
                        setState(() {
                          _group = newValue;
                        });
                      },
                      items: _groups.map((Group item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.name,
                              style: TextStyle(
                                height: 1.0,
                                fontSize: 20,
                              )),
                        );
                      }).toList(),

                      // add extra sugar..
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: SizedBox(),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                  autofocus: true,
                  controller: wordController,
                  maxLength: 25,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a new word',
                    suffixIcon: DropdownButton(
                        value: this.wordIcon == null
                            ? this.wordIcon
                            : widget._languages
                                .where((i) => i.path == this.wordIcon?.path)
                                .first,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (Language? newValue) {
                          setState(() {
                            this.wordIcon = newValue!;
                          });
                        },
                        items: widget._languages
                            .map<DropdownMenuItem<Language>>((Language v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Tab(
                                icon: Image.asset(
                              v.path,
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
            SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                  controller: translateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Translation',
                    suffixIcon: DropdownButton(
                        value: this.translationIcon == null
                            ? this.translationIcon
                            : widget._languages
                                .where(
                                    (i) => i.path == this.translationIcon?.path)
                                .first,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (Language? newValue) {
                          setState(() {
                            this.translationIcon = newValue!;
                          });
                        },
                        items: widget._languages
                            .map<DropdownMenuItem<Language>>((Language v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Tab(
                                icon: Image.asset(
                              v.path,
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Palette.second),
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
                        Utils.translate(wordController.text, wordIcon!.symbol,
                                translationIcon!.symbol)
                            .then((String value) {
                          setState(() {
                            translateController.text = value;
                          });
                        });
                      },
                    )),
                SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.36,
                    height: 50,
                    child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
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
                          print(_group);
                          widget.addWord(
                            new Entry(
                                value: wordController.text,
                                translation: translateController.text,
                                sourceLangId: wordIcon!.id!,
                                translationLangId: translationIcon!.id!,
                                groupId: _group!.id!,
                                count: 1),
                          );
                          Navigator.pop(context, 'OK');
                        })),
              ],
            ),
          ],
        )));
  }
}
