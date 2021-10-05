import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:confetti/confetti.dart';
import 'itemList.dart';
import 'langIcon.dart';
import 'utils.dart';

class Game extends StatefulWidget {
  final List<ItemList> _items;
  final Function start;
  const Game(this._items, this.start, {Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  var correctAns;
  List<ItemList> _wordsToPLay = [];
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
    wordController.text = _wordsToPLay[0].word;
    correctAns = _wordsToPLay[0].translation;
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
                  color: Colors.green,
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
                              MaterialStateProperty.all<Color>(Colors.blue),
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
                          if (_wordsToPLay[0].translation == correctAns) {
                            print("yeeeh");
                            _controllerCenter.play();
                          }
                        },
                      )),
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
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
                          if (_wordsToPLay[1].translation == correctAns) {
                            print("yeeeh");
                            _controllerCenter.play();
                          }
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
                              MaterialStateProperty.all<Color>(Colors.blue),
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
                          if (_wordsToPLay[2].translation == correctAns) {
                            print("yeeeh");
                            _controllerCenter.play();
                          }
                        },
                      )),
                  Container(
                      width: 150,
                      height: 60,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
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
                          if (_wordsToPLay[3].translation == correctAns) {
                            print("yeeeh");
                            _controllerCenter.play();
                          }
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
