// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_floor_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CharacterDao _characterDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Character` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `characterId` INTEGER, `name` TEXT, `description` TEXT, `urlImage` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CharacterDao get characterDao {
    return _characterDaoInstance ??= _$CharacterDao(database, changeListener);
  }
}

class _$CharacterDao extends CharacterDao {
  _$CharacterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _characterInsertionAdapter = InsertionAdapter(
            database,
            'Character',
            (Character item) => <String, dynamic>{
                  'id': item.id,
                  'characterId': item.characterId,
                  'name': item.name,
                  'description': item.description,
                  'urlImage': item.urlImage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _characterMapper = (Map<String, dynamic> row) => Character(
      id: row['id'] as int,
      name: row['name'] as String,
      description: row['description'] as String,
      urlImage: row['urlImage'] as String);

  final InsertionAdapter<Character> _characterInsertionAdapter;

  @override
  Future<List<Character>> findAllCharacteres() async {
    return _queryAdapter.queryList('SELECT * FROM Character',
        mapper: _characterMapper);
  }

  @override
  Future<Character> findCharacterById(int id) async {
    return _queryAdapter.query('SELECT * FROM Character WHERE characterId = ?',
        arguments: <dynamic>[id], mapper: _characterMapper);
  }

  @override
  Future<void> deleteCharacter(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Character WHERE characterId = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertCharacter(Character character) async {
    await _characterInsertionAdapter.insert(
        character, OnConflictStrategy.abort);
  }
}
