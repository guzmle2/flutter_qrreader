import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutterqrreader/src/bloc/scans_bloc.dart';
import 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:flutterqrreader/src/pages/directions_page.dart';
import 'package:flutterqrreader/src/pages/mapas_page.dart';
import 'package:flutterqrreader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scansBloc.deleteScanALl(),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createNavigatioBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
      ),
    );
  }

  _createNavigatioBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Directions'),
        ),
      ],
    );
  }

  _callPage(int current) {
    switch (current) {
      case 0:
        return MapasPage();
      case 1:
        return DirectionsPage();

      default:
        return MapasPage();
    }
  }

  _scanQR(BuildContext context) async {
//    final futuresString = 'https://es.linkedin.com/in/guzmle2';
//    final stringGeo = 'geo:43.5672,-87.9816';

    String futuresString = '';
    try {
      futuresString = await BarcodeScanner.scan();
    } catch (e) {
      futuresString = e.toString();
    }

    if (futuresString != null) {
      final scan = Scan(value: futuresString);
      scansBloc.addScan(scan);

      if (Platform.isIOS) {
        Future.delayed(
            Duration(microseconds: 750), () => utils.openScan(context, scan));
      } else {
        utils.openScan(context, scan);
      }
    }
  }
}
