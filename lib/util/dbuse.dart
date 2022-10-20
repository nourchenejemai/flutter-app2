import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scol_list.dart';

class dbuse {
  final int version = 1;
  Database? db;
  static final dbuse _dbHelper = dbuse._internal();
  dbuse._internal();
  factory dbuse() {
    return _dbHelper;
  }
  Future<Database?> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'scol1.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
        database.execute(
            'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, ' +
                'FOREIGN KEY(codClass) REFERENCES classes(codClass))');
      }, version: version);
    }
    return db;
  }

  Future<List<ScolList>> getClasses() async {
    final List<Map<String, dynamic>> maps = await db!.query('classes');
    return List.generate(maps.length, (i) {
      return ScolList(
        maps[i]['codClass'],
        maps[i]['nomClass'],
        maps[i]['nbreEtud'],
      );
    });
  }

  Future<int> insertClass(ScolList list) async {
    int codClass = await this.db!.insert(
          'classes',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return codClass;
  }
}
