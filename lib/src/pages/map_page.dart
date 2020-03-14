import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutterqrreader/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  MapController mapController = new MapController();
  var formatMap = ['dark', 'streets', 'light', 'outdoors', 'satellite'];

  int typeMap = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Scan scan = ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Coordenates QA'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapController.move(scan.getLatLng(), 11);
              },
            ),
          ],
        ),
        body: Center(
          child: _createMap(scan),
        ),
        floatingActionButton: _bottonFloating(context));
    ;
  }

  Widget _createMap(Scan scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 11,
      ),
      layers: [
        _loadMap(),
        _loadBoorMarks(scan),
      ],
    );
  }

  _loadMap() {
    return TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken':
            'pk.eyJ1Ijoicm9ub2VsNTQiLCJhIjoiY2s3cnh4MGdzMGhuNDNnbnZiYWtndHp2cCJ9.ufsKdgjQBBNRu_-zomaAXw',
        'id': 'mapbox.${formatMap[typeMap]}',
      },
    );
  }

  _loadBoorMarks(Scan scan) {
    return MarkerLayerOptions(
      markers: [
        new Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (ctx) => new Container(
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 60.0,
            ),
          ),
        ),
      ],
    );
  }

  _bottonFloating(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          if (typeMap + 1 < formatMap.length) {
            typeMap = typeMap + 1;
          } else {
            typeMap = 0;
          }
        });
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.repeat),
    );
  }
}
