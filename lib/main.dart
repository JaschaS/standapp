import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/pages/home_screen_page.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'standapp/pages/host_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureApp();
  runApp(const StandApp());
}

class StandApp extends StatefulWidget {
  const StandApp() : super(key: const Key("StandApp"));

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
      title: "StandUp-Host",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 0,
          elevation: 0,
          backgroundColor: AppColors.weisserAlsWeiss,
          title: _createHeaderTitle(),
          actions: _createActions(),
        ),
        body: _createBody(),
      ),
    );
  }

  Widget _createBody() {
    if (_user == null) return const HomeScreenPage();

    return HostPage(user: _user);
  }

  Widget _createHeaderTitle() {
    if (_user == null) return Container();

    return Container(
      alignment: Alignment.centerLeft,
      child: const Image(
        width: 60,
        height: 24,
        image: AssetImage("images/logo.png"),
      ),
    );
  }

  List<Widget> _createActions() {
    if (_user == null) return [];

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: TextButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Text("sign-out")),
      )
    ];
  }
}
