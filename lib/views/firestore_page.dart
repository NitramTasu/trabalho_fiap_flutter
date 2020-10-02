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
import 'package:trabalho_fiap_flutter/util/fab.dart';

class FirestorePage extends StatefulWidget {
  final String title;
  const FirestorePage({Key key, this.title = "Marvel"}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  List<Character> characters = List<Character>();
  CharacterDao characterDao;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FAB(),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('characters').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => buildCharacterItem(data)).toList(),
    );
  }

  Card buildCharacterItem(DocumentSnapshot data) {
    final item = Character.fromSnapshot(data);
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
