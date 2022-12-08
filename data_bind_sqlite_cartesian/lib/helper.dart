import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model.dart';

class DataBaseHelper {
  static const _databaseName = 'Sales.db';
  static const _databaseVersion = 1;

  //singleton class
  DataBaseHelper._();
  static final DataBaseHelper instance = DataBaseHelper._();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    //create tables
    await db.execute('''
      CREATE TABLE ${SalesData.tblSales} (
        ${SalesData.salesXValue} REAL NOT NULL,
        ${SalesData.salesYValue} REAL NOT NULL
      )
      ''');
  }

  // Insert
  void add(SalesData sales) async {
    var dbClient = await database;
    dbClient.insert(SalesData.tblSales, sales.toMap());
  }

  // Read
  Future<List<SalesData>> getSales() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(SalesData.tblSales,
        columns: ['${SalesData.salesXValue}', '${SalesData.salesYValue}']);
    List<SalesData> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(SalesData.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return students;
  }
  
  // Delete
  void delete(int id) async {
    var dbClient = await database;
    dbClient.execute('delete from salestable where xValue = $id');
  }
}
