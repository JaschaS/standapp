import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/background_widget.dart';
import 'package:standapp/standapp/host_screen/services/http_service.dart';
import 'package:standapp/standapp/host_screen/web/web_host_widget.dart';
import 'package:standapp/standapp/host_screen/web/web_member_widget.dart';

import '../standapp_avatars.dart';
import 'member_model.dart';

/*
 todo: 
 + current host avatar sollte sich nicht aendern, wenn ein neuer member hinzugefügt wird
 + delete member hinzufügen
 + update member soltle auch current host beeinflussen
 + delete member sollte nicht gespeichehrten host nicht speichern können
 - update member save sollte nicht clickbar sein, wenn auch daten geändert worden sind
*/

class HostScreenWidget extends StatefulWidget {
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

    _futureMembers = HttpService.getMembers();
    _currentHost = HttpService.getCurrentHost();
  }

  void _findHost() {
    final member = HttpService.getRecommendation();
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
    HttpService.postHost(member);
    setState(() {
      _canSave = false;
    });
  }

  void _onInfo(final Member? oldMember, final Member newMember) {
    if (oldMember == null) return;
    if (oldMember != newMember) {
      final members = HttpService.patchMember(oldMember, newMember);
      final currentHost = HttpService.getCurrentHost();
      setState(() {
        _canSave = false;
        _futureMembers = members;
        _currentHost = currentHost;
      });
    }
  }

  void _onRemove(final String member) async {
    final members = HttpService.deleteMember(member);
    final host = await _currentHost;
    Future<Member>? newHost = null;

    if (member == host.name) {
      newHost = HttpService.getCurrentHost();
    }

    setState(() {
      _canSave = false;
      if (newHost != null) _currentHost = newHost;
      _futureMembers = members;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
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
            return CircularProgressIndicator();
          },
        ),
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
