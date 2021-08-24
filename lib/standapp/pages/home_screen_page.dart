import 'package:flutter/material.dart';
import 'package:standapp/standapp/widgets/background_widget.dart';
import 'package:standapp/standapp/widgets/home_screen/email_signin.dart';
import 'package:standapp/standapp/widgets/home_screen/home_screen_header.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage() : super(key: const Key("HomeScreenPage"));

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenPage> {
  @override
  Widget build(final BuildContext context) {
    return BackgroundWidget(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreenHeader(),
          EmailSignIn(),
        ],
      ),
    );
  }
}
