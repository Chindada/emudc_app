import 'package:flutter/material.dart';
import 'package:emudc_app/Homepage.dart';

void main() {
  runApp(EmuApp());
}

class EmuApp extends StatelessWidget {
  const EmuApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'emuApp',
      home: HomePage(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
