import 'package:flutter/material.dart';
import 'package:flutterqrreader/src/pages/home_page.dart';
import 'package:flutterqrreader/src/pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRReader',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'mapa': (BuildContext context) => MapPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.pinkAccent
      ),
    );
  }
}
