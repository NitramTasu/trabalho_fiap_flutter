import 'dart:async';

import 'package:flutter/material.dart' hide Router;

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:trabalho_fiap_flutter/dao/characterDao.dart';
import 'package:trabalho_fiap_flutter/models/character.dart';
import 'package:trabalho_fiap_flutter/mobx/home_controller.dart';
import 'package:trabalho_fiap_flutter/persistence/app_floor_db.dart';

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
    super.initState();
  }

  void openDataBase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    characterDao = database.characterDao;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.black,
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
                  child: buildListView(homeController),
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            width: MediaQuery.of(context).size.width,
            top: moveTop.toDouble(),
            child: Image.network(
                "https://d23.com/app/uploads/2019/07/marvel-op-2-1180w-600hIris-780x440-1563899008.jpg"),
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
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 40,
              width: 100,
              child: RaisedButton(
                child: FutureBuilder(
                  future: checkAdded(item),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data);
                    } else {
                      return Text("Nada");
                    }
                  },
                ),
                onPressed: () => {addCharacter(item)},
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }

  Future<String> checkAdded(Character item) async {
    Character character =
        await characterDao.findCharacterById(item.characterId);
    if (character == null) {
      return 'Add';
    } else {
      return 'Adicionado';
    }
  }

  void addCharacter(Character item) {
    characterDao.findCharacterById(item.characterId).then((character) {
      if (character == null) {
        characterDao.insertCharacter(item);
      } else {
        characterDao.deleteCharacter(item.characterId);
      }
      characterDao.findAllCharacteres().then((characteres) {
        characteres.forEach((item) {
          print('teste ' + item.name);
        });
      });
      setState(() {});
    });
  }
}
