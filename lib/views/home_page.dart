import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Router;

import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:trabalho_fiap_flutter/dao/characterDao.dart';
import 'package:trabalho_fiap_flutter/models/character.dart';
import 'package:trabalho_fiap_flutter/mobx/home_controller.dart';
import 'package:trabalho_fiap_flutter/persistence/app_floor_db.dart';
import 'package:trabalho_fiap_flutter/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_fiap_flutter/util/fab.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Marvel"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Character> characters = List<Character>();
  List<Character> charactersDB = List<Character>();
  HomeController homeController;
  Timer timer;
  double currentOpacity = 0;
  int moveTop = 250;
  CharacterDao characterDao;
  static const platform = const MethodChannel('internet/sign');
  bool isConnected = false;

  @override
  void initState() {
    openDataBase();

    homeController = GetIt.instance<HomeController>();
    timer = Timer(Duration(seconds: 3), () {
      setState(() {
        moveTop = 0;
      });
    });

    charactersDB = homeController.characters;
    checkInternet();

    super.initState();
  }

  void openDataBase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    characterDao = database.characterDao;
  }

  void checkInternet() async {
    bool result = await platform.invokeMethod('isConnected');

    setState(() {
      isConnected = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    var currentThemeType = Provider.of<ThemeProvider>(context).currentThemeType;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FAB(),
      body: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: currentOpacity,
            duration: Duration(seconds: 1),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 118,
                ),
                Flexible(
                  child: isConnected
                      ? buildListView(homeController)
                      : Container(
                          child: Center(
                            child: Text(
                              "Offline",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            width: MediaQuery.of(context).size.width,
            top: moveTop.toDouble(),
            child: Image.asset("images/marvel_logo.jpg"),
            onEnd: () {
              setState(() {
                currentOpacity = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildListView(HomeController homeController) {
    return FutureBuilder(
      builder: (context, snapdata) {
        if (snapdata.hasData == false) {
          return Container(
            child: Center(
              child: Text("Carregando..."),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapdata.data.length,
          itemBuilder: (_, index) {
            Character item = snapdata.data[index];
            return buildCharacterItem(item);
          },
        );
      },
      future: homeController.getCharacterList(),
    );
  }

  Card buildCharacterItem(Character item) {
    return Card(
        margin: EdgeInsets.only(top: 30),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.network(
                item.urlImage,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                item.name,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPersistButton(item, "Floor", () => checkFloorAdded(item),
                    () => addInFloor(item)),
                buildPersistButton(
                    item,
                    "Firestone",
                    () => checkFirestoneAdded(item),
                    () => addInFirestone(item)),
              ],
            ),
            //buildPersistButton(item),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }

  Future<bool> checkFloorAdded(Character item) async {
    Character character =
        await characterDao.findCharacterById(item.characterId);
    return character != null;
  }

  Future<bool> checkFirestoneAdded(Character item) async {
    CollectionReference collection =
        Firestore.instance.collection('characters');

    QuerySnapshot query = await collection
        .where('characterId', isEqualTo: item.characterId)
        .getDocuments();

    if (query.documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  void addInFloor(Character item) {
    characterDao.findCharacterById(item.characterId).then((character) {
      if (character == null) {
        characterDao.insertCharacter(item);
      } else {
        characterDao.deleteCharacter(item.characterId);
      }
      setState(() {});
    });
  }

  void addInFirestone(Character item) {
    CollectionReference characters =
        Firestore.instance.collection('characters');

    characters.add({
      'characterId': item.characterId,
      'name': item.name,
      'description': item.description,
      'urlImage': item.urlImage,
    }).then((value) {
      setState(() {});
    }).catchError((error) => print("Failed to add character: $error"));
  }

  void removeFromFirestone(Character item) {
    CollectionReference characters =
        Firestore.instance.collection('characters');

    characters
        .add({
          'description': item.description, // John Doe
        })
        .then((value) => print("Character Added"))
        .catchError((error) => print("Failed to add character: $error"));
  }

  Widget buildPersistButton(
    Character item,
    String label,
    Function actionF,
    Function onPressedEvent,
  ) {
    Future<bool> callAsyncFetch() => actionF();
    return RaisedButton(
      padding: const EdgeInsets.all(0.0),
      child: FutureBuilder(
        future: callAsyncFetch(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data
                ? buttonLayout("Remover do $label")
                : buttonLayout("Adicionar ao $label");
          } else {
            return buttonLayout("Carregando...");
          }
        },
      ),
      onPressed: onPressedEvent,
    );
  }
}

Widget buttonLayout(String label) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color(0xFFd40441),
          Color(0xFFff0a4d),
        ],
      ),
    ),
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
  );
}
