import 'package:flutter/material.dart';
import 'package:future_words/newWord.dart';
import 'package:flutter/services.dart';
import 'package:future_words/sqlHelper.dart';
import 'itemCard.dart';
import 'newWord.dart';
import 'game.dart';
import 'package:flutter/widgets.dart';
import 'models/entry.dart';
import 'models/group.dart';
import 'models/language.dart';
import 'palette.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
        primarySwatch: Palette.kToDark,
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
  final DatabaseService _databaseService = DatabaseService();
  List<Entry> _entries = [];
  List<Language> _languages = [];
  List<Group> _groups = [];
  Group? _group;
  Map<int, String> _languagesdicc = {};

  //The index selected in the menu bar
  int _selectedIndex = 0;

  void _showDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Necessary actions',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.green)),
        content: const Text(
            'To use this mode you need to add at least 5 words.',
            style: const TextStyle(fontSize: 18, color: Colors.black)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addEntry(Entry entry) async {
    await _databaseService.insertEntry(entry);
    var aux = await _databaseService.entries(_group!.id!);
    setState(() {
      _entries = aux;
    });
  }

  void _addGroup(Group group) async {
    await _databaseService.insertGroup(group);
    var aux = await _databaseService.groups();
    setState(() {
      _groups = aux;
    });
  }

  void _deleteEntry(int id) async {
    await _databaseService.deleteEntry(id);
    List<Entry> _aux = await _databaseService.entries(_group!.id!);
    setState(() {
      _entries = _aux;
    });
  }

  void _updateVTEntry(int index, String value, String translation) {
    Entry toUpdate = _entries[index];
    toUpdate.value = value;
    toUpdate.translation = translation;
    _databaseService.updateEntry(toUpdate);
    setState(() {});
  }

  void _updateCEntry(int id, int counter) async {
    Entry toUpdate = _entries.where((i) => i.id == id).first;
    toUpdate.count = toUpdate.count! + counter;
    await _databaseService.updateEntryById(toUpdate, id);
    List<Entry> _aux = await _databaseService.entries(_group!.id!);
    setState(() {
      _entries = _aux;
    });
  }

  void _startGame() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Game(_entries, _startGame, _updateCEntry));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => new NewWord(
                _addEntry, _addGroup, _languages, _groups, _databaseService));
      } else if (index == 1) {
        if (_entries.length >= 5) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Game(_entries, _startGame, _updateCEntry));
        } else {
          _showDialog();
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
    print("initState");

    _databaseService.languages().then((List<Language> value) {
      setState(() {
        _languages = value;
        _languages.forEach((value) {
          _languagesdicc[value.id!] = value.path;
        });
      });
    });
    _databaseService.groups().then((List<Group> value) {
      setState(() {
        _groups = value;
        _group = _groups[0];
      });
      _databaseService.entries(_group!.id!).then((List<Entry> value) {
        setState(() {
          _entries = value;
        });
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
          toolbarHeight: 70,
          title: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage("assets/icon.png"),
                ),
              ),
              SizedBox(width: 1),
              Text(
                widget.title,
                style: TextStyle(fontSize: 21),
              ),
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<Group>(
                  isExpanded: true,
                  value: _group == null
                      ? _group
                      : _groups.where((i) => i.id == _group?.id).first,
                  onChanged: (Group? newValue) async {
                    var aux = await _databaseService.entries(newValue!.id!);
                    setState(() {
                      _group = newValue;
                      _entries = aux;
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
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 42,
                  underline: SizedBox(),
                ),
              )
            ],
          )),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          var item = _entries[index];
          return Card(
              elevation: 5,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ItemCard(
                            item, index, _deleteEntry, _updateVTEntry));
                  },
                  child: ListTile(
                      leading: Text((index + 1).toString(),
                          style:
                              TextStyle(fontSize: 40.0, color: Colors.green)),
                      title: Row(
                        children: [
                          Image.asset(
                            _languagesdicc[item.sourceLangId].toString(),
                            package: 'country_icons',
                            width: 25.0,
                            height: 25.0,
                          ),
                          SizedBox(width: 5),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              item.value,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Image.asset(
                            _languagesdicc[item.translationLangId].toString(),
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
        backgroundColor: Palette.kToDark,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Play',
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
