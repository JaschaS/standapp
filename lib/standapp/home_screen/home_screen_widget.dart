import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';

import 'signin_page.dart';
import 'header_widget.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWidget> {
  @override
  Widget build(final BuildContext context) {
    return BackgroundWidget(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreenHeader(),
          EmailSignInPage(),
        ],
      ),
    );
  }
}
