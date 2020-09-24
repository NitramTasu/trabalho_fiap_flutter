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

class FloorPage extends StatefulWidget {
  final String title;
  const FloorPage({Key key, this.title = "Marvel"}) : super(key: key);

  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  List<Character> characters = List<Character>();
  CharacterDao characterDao;

  @override
  void initState() {
    openDataBase();

    super.initState();
  }

  void openDataBase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    var charactedDB = await database.characterDao.findAllCharacteres();
    setState(() {
      characters = charactedDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        children: [
          SpeedDialChild(
            child: Icon(Icons.accessibility, color: Colors.white),
            backgroundColor: Colors.deepOrange,
            onTap: () => print('Salvos no Firestone'),
            label: 'Salvos no Firestone',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.deepOrangeAccent,
          ),
          SpeedDialChild(
            child: Icon(Icons.brush, color: Colors.white),
            backgroundColor: Colors.black,
            onTap: () => print('Salvos no Floor'),
            label: 'Salvos no Floor',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
        ],
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (_, index) {
        Character item = characters[index];
        return buildCharacterItem(item);
      },
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
            //buildPersistButton(item),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
