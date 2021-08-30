import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'itemList.dart';

class ItemCard extends StatefulWidget {
  final ItemList item;
  final int index;
  final Function delete;
  final Function update;
  const ItemCard(this.item, this.index, this.delete, this.update, {Key? key})
      : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  TextEditingController wordController = new TextEditingController();
  TextEditingController translateController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    wordController.text = widget.item.word;
    translateController.text = widget.item.translation;
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
                  'ITEM: ' + (widget.index + 1).toString(),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text(
                      "DELETE",
                      style: TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      widget.delete(widget.index);
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text(
                      "UPDATE",
                      style: TextStyle(
                        height: 1.0,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      widget.update(widget.index, wordController.text,
                          translateController.text);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
