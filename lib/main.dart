import 'package:flutter/material.dart';
import 'package:future_words/newWord.dart';
import 'package:flutter/services.dart';
import 'itemList.dart';
import 'itemCard.dart';
import 'newWord.dart';
import 'game.dart';
import 'stats.dart';
import 'utils.dart';

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
      debugShowCheckedModeBanner: false,
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
  //List with all items
  List<ItemList> _listOfItems = [];
  //Map for the image path from name
  Map<String, String> _langdicc = {
    "en": "icons/flags/png/us.png",
    "de": "icons/flags/png/de.png",
    "es": "icons/flags/png/mx.png"
  };
  //The index selected in the menu bar
  int _selectedIndex = 0;

  void _addToList(ItemList item) {
    setState(() {
      Iterable<ItemList> element = _listOfItems.where((element) {
        return element.word == item.word;
      });
      if (element.isEmpty) {
        _listOfItems.add(item);
      } else {
        int index = _listOfItems.indexOf(element.first);
        _listOfItems[index].count++;
      }
      Utils.updateFileFromList(_listOfItems);
    });
  }

  void _deleteFromList(int index) {
    setState(() {
      _listOfItems.removeAt(index);
      Utils.updateFileFromList(_listOfItems);
    });
  }

  void _updateList(int index, String word, String translate) {
    setState(() {
      _listOfItems[index].word = word;
      _listOfItems[index].translation = translate;
      Utils.updateFileFromList(_listOfItems);
    });
  }

  void _startGame() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Game(_listOfItems, _startGame));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => NewWord(_addToList));
      } else if (index == 1) {
        if (_listOfItems.length > 4) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Game(_listOfItems, _startGame));
        }
      } else {
        if (_listOfItems.length > 4) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Stats(_listOfItems));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Utils.getListOfWords().then((List<ItemList> value) {
      setState(() {
        _listOfItems = value;
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage("assets/icon.png"),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _listOfItems.length,
        itemBuilder: (context, index) {
          var item = _listOfItems[index];
          return Card(
              elevation: 5,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ItemCard(
                            item, index, _deleteFromList, _updateList));
                  },
                  child: ListTile(
                      leading: Text((index + 1).toString(),
                          style:
                              TextStyle(fontSize: 40.0, color: Colors.green)),
                      title: Row(
                        children: [
                          Image.asset(
                            _langdicc[item.origin].toString(),
                            package: 'country_icons',
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 5),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              item.word,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Image.asset(
                            _langdicc[item.dest].toString(),
                            package: 'country_icons',
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            item.translation,
                            softWrap: true,
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
