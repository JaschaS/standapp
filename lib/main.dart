import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:standapp/standapp/pages/home_screen_page.dart';
import 'package:standapp/standapp/host_screen/member_bar.dart';
import 'package:standapp/standapp/host_screen/member_model.dart';
import 'package:standapp/standapp/services/http_service.dart';
import 'package:standapp/standapp/host_screen/web_board_button.dart';
import 'package:standapp/standapp/host_screen/web_dialog.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'standapp/pages/host_page.dart';

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
          centerTitle: false,
          leadingWidth: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _createHeaderTitle(),
          actions: _createActions(),
        ),
        body: _createBody(),
      ),
    );
  }

  Widget _createBody() {
    if (_user == null) return HomeScreenPage();

    return HostPage(user: _user);
  }

  Widget _createHeaderTitle() {
    if (_user == null) return Container();

    return Container(
      alignment: Alignment.centerLeft,
      child: Image(
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
      child: FutureBuilder<List<Member>>(
        future: _members,
        builder: (context, members) {
          if (members.connectionState != ConnectionState.done) {
            return LoadingMemberWidget();
          }

          if (members.hasData) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _memberWidget(members.data),
              ],
            );
          }

          if (members.hasError) {
            return _showError(members);
          }

          return LoadingMemberWidget();
        },
      ),
    );
  }

  Widget _memberWidget(final List<Member>? members) {
    return ListView(
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
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _generateMembers(members),
            ),
          ),
        ),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }

  List<Widget> _generateMembers(final List<Member>? members) {
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
}

class LoadingMemberWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.baby_blue,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: _memberBar(),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: 797,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _loadingMembers(),
              ),
            ),
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }

  Widget _memberBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.light_grey,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        const SizedBox(
          width: 592,
        ),
        Container(
          width: 55,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.light_grey,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _loadingMembers() {
    return List.generate(
      9,
      (index) {
        return Shimmer.fromColors(
          baseColor: AppColors.light_grey,
          highlightColor: AppColors.weisser_als_weiss,
          child: Container(
            width: 259,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.light_grey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        );
      },
    );
  }
}
