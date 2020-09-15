// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:trabalho_fiap_flutter/dao/characterDao.dart';
import 'package:trabalho_fiap_flutter/models/character.dart';

part 'app_floor_db.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Character])
abstract class AppDatabase extends FloorDatabase {
  CharacterDao get characterDao;
}
