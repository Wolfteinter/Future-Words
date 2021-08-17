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
      title: 'Future words',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Future words'),
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
  IconVal dropdownValueInput = IconVal("icons/flags/png/us.png", "en");
  IconVal dropdownValueOutput = IconVal("icons/flags/png/mx.png", "es");
  TextEditingController input = new TextEditingController();
  TextEditingController output = new TextEditingController();

  TextEditingController inputGame = new TextEditingController();
  TextEditingController outputGame = new TextEditingController();

  TextEditingController getItemInput = new TextEditingController();
  TextEditingController getItemOutput = new TextEditingController();

  Map<String, String> diccLang = {
    "en": "icons/flags/png/us.png",
    "de": "icons/flags/png/de.png",
    "es": "icons/flags/png/mx.png"
  };
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    readFileAsync().then((List result) {
      if (result.isNotEmpty) {
        setState(() {
          data = result;
          data.forEach((element) {
            items.add(MessageItem(
                element["word"],
                element["translate"],
                element["count"],
                dropdownValueInput.simbol,
                dropdownValueOutput.simbol));
          });
          dropdownitems = [
            IconVal("icons/flags/png/us.png", "en"),
            IconVal("icons/flags/png/de.png", "de"),
            IconVal("icons/flags/png/mx.png", "es")
          ];
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
      resBody["words"].add({
        "word": "hello",
        "translate": "hola",
        "count": 1,
        "origin": "en",
        "dest": "es"
      });
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
    var translation = await translator
        .translate(input.text, to: dropdownValueOutput.simbol)
        .catchError((e) {
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
    int index =
        data.indexWhere((element) => element["word"] == word.toLowerCase());
    if (index >= 0) {
      data[index]["count"]++;
      setState(() {
        items.clear();
        data.forEach((element) {
          items.add(MessageItem(element["word"], element["translate"],
              element["count"], element["origin"], element["dest"]));
        });
      });
      flag = false;
    }
    if (flag) {
      String val;
      if (output.text.isEmpty) {
        var translation = await translator.translate(input.text,
            to: dropdownValueOutput.simbol);
        val = translation.text;
      } else {
        val = output.text;
      }

      setState(() {
        items.clear();
        data.add({
          "word": word.toLowerCase(),
          "translate": val.toLowerCase(),
          "count": 1,
          "origin": dropdownValueInput.simbol,
          "dest": dropdownValueOutput.simbol
        });
        data.forEach((element) {
          items.add(MessageItem(element["word"], element["translate"],
              element["count"], element["origin"], element["dest"]));
        });
      });
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
    Navigator.pop(context, 'OK');
  }

  void _showModal() {
    dropdownValueInput = dropdownitems[0];
    dropdownValueOutput = dropdownitems[2];
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
                      autofocus: true,
                      controller: input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a new word',
                        suffixIcon: DropdownButton(
                            value: dropdownValueInput,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 30,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (IconVal? newValue) {
                              setState(() {
                                dropdownValueInput = newValue!;
                              });
                            },
                            items: dropdownitems.map<DropdownMenuItem<IconVal>>(
                                (IconVal value) {
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
                      controller: output,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Here is the translate word',
                        suffixIcon: DropdownButton(
                            value: dropdownValueOutput,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 30,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (IconVal? newValue) {
                              setState(() {
                                dropdownValueOutput = newValue!;
                              });
                            },
                            items: dropdownitems.map<DropdownMenuItem<IconVal>>(
                                (IconVal value) {
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

  void _correctAns() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Correct answer',
          style: TextStyle(fontSize: 30),
        ),
        content: const Text(
          "Congratulations",
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    var rng = new Random();
    List wordsToPLay = [];
    while (wordsToPLay.length < 4) {
      while (!wordsToPLay.contains(data[_random = rng.nextInt(data.length)])) {
        wordsToPLay.add(data[_random]);
      }
    }
    inputGame.text = wordsToPLay[0]["word"];
    var correctAns = wordsToPLay[0]["translate"];
    wordsToPLay.shuffle();
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
                      controller: inputGame,
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
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            wordsToPLay[0]["translate"],
                            style: TextStyle(
                              height: 1.0,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (wordsToPLay[0]["translate"] == correctAns) {
                              _correctAns();
                            }
                          },
                        )),
                    Container(
                        width: 150,
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            wordsToPLay[1]["translate"],
                            style: TextStyle(
                              height: 1.0,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (wordsToPLay[1]["translate"] == correctAns) {
                              _correctAns();
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
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            wordsToPLay[2]["translate"],
                            style: TextStyle(
                              height: 1.0,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (wordsToPLay[2]["translate"] == correctAns) {
                              _correctAns();
                            }
                          },
                        )),
                    Container(
                        width: 150,
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: Text(
                            wordsToPLay[3]["translate"],
                            style: TextStyle(
                              height: 1.0,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (wordsToPLay[3]["translate"] == correctAns) {
                              _correctAns();
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
                      height: 50,
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
                          Navigator.pop(context, 'OK');
                          _startGame();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void _personalPresentation() {
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
          child: Column(
            children: [
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
                  'INFORMATION',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white),
                )),
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("assets/me.jpeg"),
              ),
              Text(
                'Wolfteinter',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'onderfra@gmail.com',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.contact_page,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'github.com/Wolfteinter',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Source Sans Pro',
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              )
            ],
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
                    'STATS',
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _showModal();
      } else if (index == 1) {
        _startGame();
      } else {
        _stats();
      }
    });
  }

  void _getItem(MessageItem item, int index) {
    getItemInput.text = item.sender;
    getItemOutput.text = item.body;
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
                    'ITEM: ' + (index + 1).toString(),
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
                      controller: getItemInput,
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
                      controller: getItemOutput,
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
                        int indexDel = 0;
                        for (var i = 0; i < data.length; i++) {
                          if (data[i]["word"] == item.sender) {
                            indexDel = i;
                            break;
                          }
                        }
                        data.removeAt(indexDel);
                        setState(() {
                          items.clear();
                          data.forEach((element) {
                            items.add(MessageItem(
                                element["word"],
                                element["translate"],
                                element["count"],
                                element["origin"],
                                element["dest"]));
                          });
                        });
                        Navigator.pop(context, 'OK');
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
                        for (var i = 0; i < data.length; i++) {
                          if (data[i]["word"] == item.sender) {
                            data[i]["word"] = getItemInput.text;
                            data[i]["translate"] = getItemOutput.text;
                            break;
                          }
                        }
                        setState(() {
                          items.clear();
                          data.forEach((element) {
                            items.add(MessageItem(
                                element["word"],
                                element["translate"],
                                element["count"],
                                element["origin"],
                                element["dest"]));
                          });
                          Navigator.pop(context, 'OK');
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/icon.png",
              width: 50.0,
              height: 50.0,
            ),
            onPressed: () {
              _personalPresentation();
            },
          )
        ],
        toolbarHeight: 60,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return Card(
              elevation: 5,
              child: InkWell(
                  onTap: () {
                    _getItem(item, index);
                  },
                  child: ListTile(
                      leading: Text((index + 1).toString(),
                          style:
                              TextStyle(fontSize: 40.0, color: Colors.green)),
                      title: Row(
                        children: [
                          Image.asset(
                            diccLang[item.origin].toString(),
                            package: 'country_icons',
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            item.sender,
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Image.asset(
                            diccLang[item.dest].toString(),
                            package: 'country_icons',
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            item.body,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(item.count.toString(),
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.green)))));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: 'Stats',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// A ListItem that contains data to display a message.
class MessageItem {
  final String sender;
  final String body;
  final int count;
  String origin;
  String dest;

  MessageItem(this.sender, this.body, this.count, this.origin, this.dest);
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
