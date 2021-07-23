
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';
import 'package:standapp/standapp/host_screen/http_service.dart';
import 'package:standapp/standapp/host_screen/member_model.dart';
import 'package:standapp/standapp/host_screen/select_host_widget.dart';

import '../../main.dart';

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