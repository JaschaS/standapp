import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';

import '../home_screen/email_signin_widget.dart';
import '../home_screen/header_widget.dart';

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
          EmailSignInWidget(),
        ],
      ),
    );
  }
}
