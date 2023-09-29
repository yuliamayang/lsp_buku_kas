import 'dart:io';
import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataHelper {
  late Database db;

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}buku_kas.db';
    var itemDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return itemDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cashflow (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type INTEGER,
      amount INTEGER,
      description TEXT,
      date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      password TEXT
      )
    ''');
    await db.execute(''' 
    INSERT INTO users (username, password) VALUES ('user', 'user')
    ''');
  }

  //auth users
  Future<bool> authUser(String username, String password) async {
    db = await initDb();
    var result = await db.rawQuery('''
      SELECT * FROM users WHERE username = '$username' AND password = '$password'
    ''');
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //update password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    db = await initDb();
    var result = await db.rawQuery(
        'SELECT * FROM users WHERE username = "user" AND password = "$oldPassword"');
    if (result.isNotEmpty) {
      await db.rawUpdate(
          'UPDATE users SET password = "$newPassword" WHERE username = "user"');
      return true;
    } else {
      return false;
    }
  }

  //Select Cashflow
  Future<List<CashFlow>> selectCashFlow() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps =
        await db.query('cashflow', orderBy: 'date');
    return List.generate(maps.length, (i) {
      return CashFlow(
        id: maps[i]['id'],
        type: maps[i]['type'],
        amount: maps[i]['amount'],
        description: maps[i]['description'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<CashFlow>> selectCashFlowByMonth() async {
    Database db = await initDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM cashflow WHERE strftime('%m', date) = strftime('%m', 'now') order by date
    ''');
    return List.generate(maps.length, (i) {
      return CashFlow(
        id: maps[i]['id'],
        type: maps[i]['type'],
        amount: maps[i]['amount'],
        description: maps[i]['description'],
        date: maps[i]['date'],
      );
    });
  }

  //Insert Cashflow
  Future<void> insertCashFlow(CashFlow cashFlow) async {
    Database db = await initDb();
    await db.insert(
      'cashflow',
      cashFlow.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future close() async {
    Database db = await initDb();
    db.close();
  }
}
