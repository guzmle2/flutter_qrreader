import 'package:flutter/material.dart';
import 'package:flutterqrreader/src/bloc/scans_bloc.dart';
import 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:flutterqrreader/src/utils/utils.dart' as utils;

class DirectionsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  DirectionsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();

    return StreamBuilder<List<Scan>>(
      stream: scansBloc.scanStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<Scan>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(child: Text('No data'));
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, int index) => Dismissible(
            child: ListTile(
              onTap: () => utils.openScan(context, scans[index]),
              leading: Icon(
                Icons.cloud_queue,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(scans[index].value),
              subtitle: Text('ID: ${scans[index].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ),
            key: UniqueKey(),
            onDismissed: (direction) async =>
                await scansBloc.deleteScan(scans[index].id),
            background: Container(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
