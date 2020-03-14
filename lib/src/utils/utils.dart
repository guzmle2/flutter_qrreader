
import 'package:flutter/material.dart';
import 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

openScan(BuildContext context, Scan scan) async {
  if (scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
    return;
  }

  Navigator.pushNamed(context, 'mapa', arguments: scan);
}
