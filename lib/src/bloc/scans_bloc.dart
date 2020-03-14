import 'dart:async';

import 'package:flutterqrreader/src/bloc/Validator.dart';
import 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:flutterqrreader/src/providers/db_provider.dart';

class ScansBloc extends Validator{
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    getScans();
  }

  final _scansController = StreamController<List<Scan>>.broadcast();

  Stream<List<Scan>> get scanStream => _scansController.stream.transform(validateGeo);
  Stream<List<Scan>> get scanStreamHttp => _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  deleteScan(int id) async {
    await DBProvider.db.delteScan(id);
    getScans();
  }

  deleteScanALl() async {
    await DBProvider.db.deleteAll();
    getScans();
  }

  addScan(Scan scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }
}
