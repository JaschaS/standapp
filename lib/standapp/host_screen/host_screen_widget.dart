import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';
import 'package:standapp/standapp/host_screen/services/http_service.dart';
import 'package:standapp/standapp/host_screen/web/web_host_widget.dart';
import 'package:standapp/standapp/host_screen/web/web_member_widget.dart';

import '../standapp_avatars.dart';
import 'member_model.dart';

class HostScreenWidget extends StatefulWidget {
  final User _user;

  HostScreenWidget(this._user);

  @override
  State<StatefulWidget> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreenWidget> {
  late Future<List<Member>> _futureMembers;
  late Future<Member> _currentHost;
  final String _noHostAvatar = AvatarsImages.randomBlackAvatar();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();

    _futureMembers = HttpService.getMembers(widget._user);
    _currentHost = HttpService.getCurrentHost(widget._user);
  }

  void _findHost() {
    final member = HttpService.getRecommendation(widget._user);
    setState(() {
      this._canSave = true;
      this._currentHost = member;
    });
  }

  VoidCallback? _generateSaveHost(final Member member) {
    return _canSave
        ? () {
            _saveHost(member);
          }
        : null;
  }

  void _saveHost(final Member member) {
    HttpService.postHost(widget._user, member);
    setState(() {
      _canSave = false;
    });
  }

  void _onInfo(final Member? oldMember, final Member newMember) {
    if (oldMember == null) return;
    if (oldMember != newMember) {
      final members =
          HttpService.patchMember(widget._user, oldMember, newMember);
      final currentHost = HttpService.getCurrentHost(widget._user);
      setState(() {
        _canSave = false;
        _futureMembers = members;
        _currentHost = currentHost;
      });
    }
  }

  void _onRemove(final Member member) async {
    final members = HttpService.deleteMember(widget._user, member);
    final host = await _currentHost;
    Future<Member>? newHost;

    if (member.name == host.name) {
      newHost = HttpService.getCurrentHost(widget._user);
    }

    setState(() {
      _canSave = false;
      if (newHost != null) _currentHost = newHost;
      _futureMembers = members;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return BackgroundWidget(
      topWeight: 0.5,
      bottomWeight: 0.5,
      child: FutureBuilder<List<Member>>(
        future: _futureMembers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              children: [
                _webHost(context, snapshot.data),
                WebMemberWidget(
                  widget._user,
                  members: snapshot.data,
                  callback: (members) {
                    setState(() {
                      _futureMembers = members;
                    });
                  },
                  onInfo: _onInfo,
                  onRemove: _onRemove,
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _webHost(final BuildContext context, List<Member>? members) {
    final bool hasMembers = members != null ? members.length > 0 : false;

    return FutureBuilder<Member>(
      future: _currentHost,
      builder: (context, currentHost) {
        if (currentHost.hasData) {
          if (currentHost.data!.isEmpty()) {
            return WebNoHostWidget(
              noHostAvatar: _noHostAvatar,
              findHost: hasMembers ? _findHost : null,
            );
          }

          return WebHostWidget(
            currentHost.data!,
            findHost: hasMembers ? _findHost : null,
            saveHost: _generateSaveHost(currentHost.data!),
          );
        }

        if (currentHost.hasError) {
          return Center(
            child: Text("${currentHost.error}"),
          );
        }

        return WebNoHostWidget();
      },
    );
  }
}
