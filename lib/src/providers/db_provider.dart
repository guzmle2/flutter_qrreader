import 'dart:io';

import 'package:flutterqrreader/src/models/scan_model.dart';
export 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  String BD_SCANS = 'Scans';
  static Database _dataBase;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get dataBase async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await initDB();
    return _dataBase;
  }

  initDB() async {
    Directory documenstDirectory = await getApplicationDocumentsDirectory();
    String path = join(documenstDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE $BD_SCANS ('
            ' id INTEGER PRIMARY KEY, '
            'type TEXT, '
            ' value TEXT '
            ' ) ');
      },
    );
  }

  newScanRaw(Scan newScan) async {
    final db = await dataBase;
    final query =
        "INSERT Into $BD_SCANS ( id, type, value) VALUES (${newScan.id}, '${newScan.type}','${newScan.value}'";
    print(query);
    final res = await db.rawInsert(query);

    return res;
  }

  Future<int> newScan(Scan newScan) async {
    final db = await dataBase;
    final res = await db.insert(BD_SCANS, newScan.toJson());
    return res;
  }

  Future<Scan> getScanId(int id) async {
    final db = await dataBase;
    final res = await db.query(BD_SCANS, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Scan.fromJson(res.first) : null;
  }

  Future<List<Scan>> getAllScans() async {
    final db = await dataBase;
    final res = await db.query(BD_SCANS);
    List<Scan> retorno =
        res.isNotEmpty ? res.map((scan) => Scan.fromJson(scan)).toList() : [];

    return retorno;
  }

  Future<List<Scan>> getScansType(String type) async {
    final db = await dataBase;
    final res = await db.query(BD_SCANS, where: 'type = ?', whereArgs: [type]);
    List<Scan> retorno =
        res.isNotEmpty ? res.map((scan) => Scan.fromJson(scan)).toList() : [];

    return retorno;
  }

  Future<int> updateScan(Scan scan) async {
    final db = await dataBase;
    final res = await db
        .update(BD_SCANS, scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);
    return res;
  }

  Future<int> delteScan(int id) async {
    final db = await dataBase;
    final res = await db.delete(BD_SCANS, where: 'id = ?', whereArgs: [id]);
    return res;
  }

   Future<int> deleteAll() async {
    final db = await dataBase;
    final res = await db.rawDelete('DELETE FROM $BD_SCANS ');
    return res;
  }
}
