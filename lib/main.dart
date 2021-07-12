import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/home_screen/home_screen_widget.dart';
import 'package:standapp/standapp/host_screen/host_screen_widget.dart';
import 'package:standapp/standapp/host_screen/no_host/select_host_widget.dart';
import 'package:standapp/standapp/standapp_avatars.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'standapp/host_screen/no_host/avatar_widget.dart';

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureApp();
  runApp(StandApp());
}*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            NoHostWidget(),
            const SizedBox(
              height: 150,
            ),
            SelectDateWidget(
              onStartChange: (date) {},
              onEndChange: (date) {},
            ),
            const SizedBox(
              height: 150,
            ),
            SelectHostWidget(
              avatar: Avatar(image: AvatarsImages.ginger_freckles),
              title: "It is Jascha!",
            ),
            const SizedBox(
              height: 150,
            ),
            CurrentHostWidget(
              avatar: Avatar(image: AvatarsImages.ginger_freckles),
              title: "It is Jascha!",
            )
          ],
        ),
      ),
    );
  }
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
      title: "StandUp-Host",
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
