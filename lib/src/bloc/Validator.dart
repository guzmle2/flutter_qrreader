import 'dart:async';

import 'package:flutterqrreader/src/models/scan_model.dart';

class Validator {
  final validateGeo = StreamTransformer<List<Scan>, List<Scan>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((scan) => scan.type == 'geo').toList();
      sink.add(geoScans);
    },
  );
  final validateHttp = StreamTransformer<List<Scan>, List<Scan>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((scan) => scan.type == 'http').toList();
      sink.add(geoScans);
    },
  );
}
