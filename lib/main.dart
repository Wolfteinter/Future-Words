import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:country_icons/country_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Rememberer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'English Rememberer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<IconVal> dropdownitems = [];
  final translator = GoogleTranslator();
  int _random = 0;
  List data = [];
  List<MessageItem> items = [];
  TextEditingController input = new TextEditingController();
  TextEditingController output = new TextEditingController();
  TextEditingController inputGame = new TextEditingController();
  TextEditingController outputGame = new TextEditingController();

  @override
  void initState() {
    super.initState();
    readFileAsync().then((List result) {
      if (result.isNotEmpty) {
        setState(() {
          data = result;
          data.forEach((element) {
            items.add(MessageItem(
                element["word"], element["translate"], element["count"]));
          });
          dropdownitems = [IconVal("icons/flags/png/de.png", "de")];
        });
      }
    });
  }

  Future<List> readFileAsync() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var path = appDocDirectory.path + '/assets/data.json';
    File file = new File(path);
    if (File(path).existsSync() == false) {
      new File(path).create(recursive: true);
      var resBody = {};
      resBody["words"] = [];
      resBody["words"].add({"word": "hello", "translate": "hola", "count": 1});
      String str = json.encode(resBody);
      file.writeAsString(str);
    }
    var data;
    String raw = await file.readAsString();
    data = json.decode(raw);
    List words = data["words"];
    return words;
  }

  void _translate() async {
    var translation =
        await translator.translate(input.text, to: 'es').catchError((e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Something went wrong'),
          content: const Text("Translation could not be performed"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
    output.text = translation.text;
  }

  void _addWord() async {
    var word = input.text;
    bool flag = true;
    data.forEach((element) {
      if (element["word"] == word.toLowerCase()) {
        element["count"]++;
        flag = false;
      }
    });
    if (flag) {
      String val;
      if (output.text.isEmpty) {
        var translation = await translator.translate(input.text, to: 'es');
        val = translation.text;
      } else {
        val = output.text;
      }
      data.add({
        "word": word.toLowerCase(),
        "translate": val.toLowerCase(),
        "count": 1
      });
      setState(() {});
    }
    input.text = "";
    output.text = "";
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    var path = appDocDirectory.path + '/assets/data.json';
    var j = {};
    j["words"] = data;
    File file = new File(path);
    String str = json.encode(j);
    file.writeAsString(str);
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                      controller: input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a new word',
                      ),
                      style: TextStyle(
                          fontSize: 20.0, height: 1.0, color: Colors.black)),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: output,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Here is the translate word'),
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
                      onPressed: _translate,
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
                      onPressed: _addWord,
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _startGame() {
    var rng = new Random();
    _random = rng.nextInt(data.length);
    inputGame.text = data[_random]["word"];
    outputGame.text = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
                    'GAME',
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
                      controller: inputGame,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a new word'),
                      style: TextStyle(
                          fontSize: 20.0, height: 1.0, color: Colors.black)),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                      controller: outputGame,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'COVERED WORD'),
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
                        "UNCOVER",
                        style: TextStyle(
                          height: 1.0,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        outputGame.text = data[_random]["translate"];
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: Text(
                        "NEXT WORD",
                        style: TextStyle(
                          height: 1.0,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        var rng = new Random();
                        _random = rng.nextInt(data.length);
                        inputGame.text = data[_random]["word"];
                        outputGame.text = "";
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _stats() {
    int max_size = min(data.length, 5);
    List aux = data;
    aux.sort((a, b) => a["count"].compareTo(b["count"]));
    List<DataVal> dataGraph = [];
    for (var i = aux.length - 1; i >= aux.length - max_size; i--) {
      dataGraph.add(DataVal(aux[i]["word"], aux[i]["count"]));
    }
    print(dataGraph);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                    'STATISTICS',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  )),
                ),
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(), // Initialize category axis.
                    series: <LineSeries<DataVal, String>>[
                      // Initialize line series.
                      LineSeries<DataVal, String>(
                          dataSource: dataGraph,
                          xValueMapper: (DataVal v, _) => v.name,
                          yValueMapper: (DataVal v, _) => v.val)
                    ])
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return Card(
                elevation: 5,
                child: ListTile(
                    leading: Text((index + 1).toString(),
                        style: TextStyle(fontSize: 40.0, color: Colors.green)),
                    title: Text(
                      item.sender,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    subtitle: Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    trailing: Text(item.count.toString(),
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.green))));
          },
        ),
        floatingActionButton: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.72),
            Container(
              child: FloatingActionButton(
                onPressed: _showModal,
                child: Icon(Icons.add),
                heroTag: null,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: FloatingActionButton(
                onPressed: _startGame,
                child: Icon(Icons.gamepad),
                heroTag: null,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: FloatingActionButton(
                onPressed: _stats,
                child: Icon(Icons.view_week),
                heroTag: null,
              ),
            ),
          ],
        )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

/// A ListItem that contains data to display a message.
class MessageItem {
  final String sender;
  final String body;
  final int count;

  MessageItem(this.sender, this.body, this.count);
}

class DataVal {
  String name;
  int val;
  DataVal(this.name, this.val);
}

class IconVal {
  String path;
  String simbol;
  IconVal(this.path, this.simbol);
}
