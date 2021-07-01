import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/home_screen/home_screen_widget.dart';
import 'package:standapp/standapp/host_screen/host_screen_widget.dart';
import 'package:standapp/standapp/signin_page.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureApp();
  runApp(StandApp());
}

class StandApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StandAppState();
}

class _StandAppState extends State<StandApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    _auth.idTokenChanges().listen(_handleUserChange);
    super.initState();
  }

  void _handleUserChange(final User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: "StandApp",
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: _createActions(),
        ),
        body: _createBody(),
      ),
    );
  }

  Widget _createBody() {
    if (_user == null) return HomeScreenWidget();

    return HostScreenWidget(_user!);
  }

  List<Widget> _createActions() {
    if (_user == null) return [];

    return [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: TextButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: Text("sign-out")),
      )
    ];
  }
}
