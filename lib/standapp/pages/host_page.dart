import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/widgets/background_widget.dart';
import 'package:standapp/standapp/services/http_service.dart';
import 'package:standapp/standapp/models/member_model.dart';
import 'package:standapp/standapp/widgets/host_screen/select_host_widget.dart';
import 'package:standapp/standapp/widgets/host_screen/web_member_widget.dart';

class HostPage extends StatefulWidget {
  final User? user;

  const HostPage({this.user}) : super(key: const Key("HostPage"));

  @override
  State<StatefulWidget> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  Future<Member>? _currentHost;

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
