import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/home_screen/home_screen_widget.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';
import 'package:standapp/standapp/host_screen/member_bar.dart';
import 'package:standapp/standapp/host_screen/member_model.dart';
import 'package:standapp/standapp/host_screen/no_host/select_host_widget.dart';
import 'package:standapp/standapp/host_screen/services/http_service.dart';
import 'package:standapp/standapp/host_screen/web/web_board_button.dart';
import 'package:standapp/standapp/host_screen/web/web_dialog.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

//- Löschen von member geht nicht
// updaten von current host scheint nicht zu funktionieren
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

    return HostPage(user: _user);
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

class HostPage extends StatefulWidget {
  final User? user;

  HostPage({this.user});

  @override
  State<StatefulWidget> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  Future<Member>? _currentHost = null;

  void _updateCurrentHost() {
    setState(() {
      _currentHost = HttpService.getCurrentHost(widget.user!);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return BackgroundWidget(
      topWeight: 0.5,
      bottomWeight: 0.5,
      child: ListView(
        children: [
          HostWidget(
            user: widget.user,
            currentHost: _currentHost,
          ),
          WebMemberWidget(
            user: widget.user,
            updateCurrentHost: _updateCurrentHost,
          ),
        ],
      ),
    );
  }
}

class WebMemberWidget extends StatefulWidget {
  final User? user;
  final VoidCallback? updateCurrentHost;

  WebMemberWidget({this.user, this.updateCurrentHost});

  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<WebMemberWidget> {
  late Future<List<Member>> _members;

  @override
  void initState() {
    super.initState();

    _members = HttpService.getMembers(widget.user!);
  }

  void _onMemberInfo(final Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WebDialog(
          okText: "save",
          existingMember: member,
          callback: (final Member? oldMember, final Member newMember) {
            if (oldMember == null) return;
            if (oldMember != newMember) {
              setState(() {
                _members =
                    HttpService.patchMember(widget.user!, oldMember, newMember);
                if (widget.updateCurrentHost != null)
                  widget.updateCurrentHost!();
              });
            }
          },
        );
      },
    );
  }

  void _addMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WebDialog(
          callback: (_, member) {
            setState(() {
              _members = HttpService.addMember(widget.user!, member);
            });
          },
          okText: "  add ",
        );
      },
    );
  }

  void _onRemove(final Member member) async {
    setState(() {
      _members = HttpService.deleteMember(widget.user!, member);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
      color: AppColors.blue,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: MemberBar(
              addMember: _addMemberDialog,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 797,
              child: FutureBuilder<List<Member>>(
                  future: _members,
                  builder: (context, members) {
                    if (members.connectionState != ConnectionState.done) {
                      return _loading();
                    }

                    if (members.hasData) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _generateMemberWidget(members.data),
                      );
                    }

                    if (members.hasError) {
                      return _showError(members);
                    }

                    return _loading();
                  }),
            ),
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }

  List<Widget> _generateMemberWidget(List<Member>? members) {
    return members!.map(
      (entry) {
        return WebBoardButton(
          entry.name,
          onInfo: () {
            _onMemberInfo(entry);
          },
          onRemove: () {
            _onRemove(entry);
          },
        );
      },
    ).toList();
  }

  Widget _showError(final AsyncSnapshot<List<Member>?> snapshot) {
    return Center(
      child: Text("${snapshot.error}"),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
