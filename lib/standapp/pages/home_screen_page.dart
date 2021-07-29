import 'package:flutter/material.dart';
import 'package:standapp/standapp/widgets/background_widget.dart';
import 'package:standapp/standapp/widgets/home_screen/email_signin.dart';
import 'package:standapp/standapp/widgets/home_screen/home_screen_header.dart';

class HomeScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenPage> {
  @override
  Widget build(final BuildContext context) {
    return BackgroundWidget(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreenHeader(),
          EmailSignIn(),
        ],
      ),
    );
  }
}
