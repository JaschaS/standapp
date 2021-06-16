import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/host_screen_widget.dart';

void main() {
  runApp(StandApp());
}

class StandApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: "StandApp",
      home: HostScreenWidget(),
    );
  }
}
