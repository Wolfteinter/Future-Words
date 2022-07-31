import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:future_words/palette.dart';
import 'models/entry.dart';

class Game extends StatefulWidget {
  final List<Entry> _items;
  final Function start;
  final Function? _updateCEntry;
  const Game(this._items, this.start, this._updateCEntry, {Key? key})
      : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  var correctAns;
  int? _correctId;
  List<Entry> _wordsToPLay = [];
  TextEditingController wordController = new TextEditingController();
  ConfettiController _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 1));

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  void checkAnswer(String response) {
    if (response == correctAns) {
      _showDialog(true, "Correct", "You want to decresse the counter");
      _controllerCenter.play();
    } else {
      _showDialog(false, "Incorrect", "You want to increse the counter");
    }
  }

  void _showDialog(bool correct, String opt, String text) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(opt,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: (correct == true) ? Colors.green : Colors.red)),
        content: Text(text,
            style: const TextStyle(fontSize: 18, color: Colors.black)),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () {
              widget._updateCEntry!(_correctId, (correct == true ? -1 : 1));
              Navigator.pop(context, 'OK');
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                height: 1.0,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              'No',
              style: TextStyle(
                height: 1.0,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void ganerateQuestions() {
    List items = widget._items;
    var rng = new Random();
    int _random;
    while (true) {
      while (true) {
        if (!_wordsToPLay
            .contains(items[_random = rng.nextInt(items.length)])) {
          _wordsToPLay.add(items[_random]);
          break;
        }
      }
      if (_wordsToPLay.length == 4) break;
    }
    wordController.text = _wordsToPLay[0].value;
    correctAns = _wordsToPLay[0].translation;
    _correctId = _wordsToPLay[0].id;
    _wordsToPLay.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    ganerateQuestions();
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                    true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used // define a custom shape/path.
              ),
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
                  'GAME',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                )),
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                    controller: wordController,
                    enabled: false,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    style: TextStyle(
                        fontSize: 30.0, height: 1.0, color: Colors.black)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
                        ),
                        child: Text(
                          _wordsToPLay[0].translation,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(_wordsToPLay[0].translation);
                        },
                      )),
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
                        ),
                        child: Text(
                          _wordsToPLay[1].translation,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(_wordsToPLay[1].translation);
                        },
                      ))
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
                        ),
                        child: Text(
                          _wordsToPLay[2].translation,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(_wordsToPLay[2].translation);
                        },
                      )),
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Palette.second),
                        ),
                        child: Text(
                          _wordsToPLay[3].translation,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          checkAnswer(_wordsToPLay[3].translation);
                        },
                      )),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 60,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          height: 1.0,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.start();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
