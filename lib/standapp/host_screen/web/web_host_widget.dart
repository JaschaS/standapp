import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_avatars.dart';

import '../date_widget.dart';
import '../host_button.dart';
import '../host_title.dart';
import 'package:intl/intl.dart';

import '../member_model.dart';

class WebNoHostWidget extends _WebHost {
  final String _noHostAvatar;

  WebNoHostWidget({String? noHostAvatar, VoidCallback? findHost})
      : this._noHostAvatar = noHostAvatar ?? AvatarsImages.randomBlackAvatar(),
        super(findHost: findHost);

  @override
  List<Widget> _hostWidget() {
    return [_noHostDescription(), _Avatar(image: _noHostAvatar)];
  }

  Widget _noHostDescription() {
    final String from = _from();
    final String until = _until();

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: HostTitle("You don't have a host yet"),
          ),
          Row(children: [
            DateWidget("Find a new host from ", "$from"),
            const SizedBox(width: 5),
            DateWidget("until  ", "$until"),
          ]),
        ]);
  }

  @override
  String _from() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  @override
  String _until() {
    final DateTime now = DateTime.now().add(const Duration(days: 7));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }
}

class WebHostWidget extends _WebHost {
  final Member _member;

  WebHostWidget(Member member, {VoidCallback? findHost, VoidCallback? saveHost})
      : this._member = member,
        super(findHost: findHost, saveHost: saveHost);

  @override
  List<Widget> _hostWidget() =>
      [_description(_member), _Avatar(image: _member.avatar)];

  Widget _description(final Member member) {
    final String from = _from();
    final String until = _until();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: HostTitle("Hi, I am ${member.name}"),
        ),
        Row(
          children: [
            DateWidget("I am your host from ", "$from"),
            const SizedBox(width: 5),
            DateWidget("until  ", "$until"),
          ],
        ),
      ],
    );
  }

  @override
  String _from() {
    return _member.startDate ?? "xx-xx-xxxx";
  }

  @override
  String _until() {
    return _member.endDate ?? "xx-xx-xxxx";
  }
}

abstract class _WebHost extends StatelessWidget {
  final VoidCallback? _findHost;
  final VoidCallback? _saveHost;

  _WebHost({VoidCallback? findHost, VoidCallback? saveHost})
      : this._findHost = findHost,
        this._saveHost = saveHost;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _hostWidget(),
          ),
          const SizedBox(height: 25),
          _buttonBar()
        ],
      ),
    );
  }

  List<Widget> _hostWidget();
  String _from();
  String _until();

  Widget _buttonBar() {
    return Align(
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        HostButton(
          "Find Host",
          EdgeInsets.fromLTRB(23, 5, 23, 5),
          callback: _findHost,
        ),
        const SizedBox(width: 10),
        HostButton(
          "Save Host",
          EdgeInsets.fromLTRB(23, 5, 23, 5),
          callback: _saveHost,
        ),
        const SizedBox(width: 285),
      ]),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String _image;

  _Avatar({String image = 'images/Avatar20-1.png'}) : this._image = image;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
      child: Image(
        image: AssetImage(_image),
        fit: BoxFit.cover,
      ),
    );
  }
}

/*
class WebHostWidget extends StatefulWidget {
  final bool _hasMembers;
  final String _noHostAvatar;

  WebHostWidget({hasMembers = false, String? noHostAvatar})
      : this._hasMembers = hasMembers,
        this._noHostAvatar = noHostAvatar ?? AvatarsImages.randomBlackAvatar();

  @override
  State<StatefulWidget> createState() => WebHostState();
}

class WebHostState extends State<WebHostWidget> {
  bool _canSave = false;

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: FutureBuilder<Member>(
        future: _currentHost,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _host(snapshot.data),
                const SizedBox(height: 25),
                _buttonBar(snapshot.data)
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
    );
  }

  Widget _host(final Member? host) {
    bool hasCurrentHost = host != null;
    bool hasData = false;

    if (hasCurrentHost) {
      hasData = host.name.isNotEmpty && host.avatar.isNotEmpty;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: hasCurrentHost && hasData ? _withHost(host) : _noHost(),
    );
  }

  Widget _buttonBar(final Member? member) {
    return Align(
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        HostButton(
          "Find Host",
          EdgeInsets.fromLTRB(23, 5, 23, 5),
          callback: widget._hasMembers
              ? () {
                  setState(() {
                    _canSave = true;
                    _currentHost = getNextHost();
                  });
                }
              : null,
        ),
        const SizedBox(width: 10),
        HostButton(
          "Save Host",
          EdgeInsets.fromLTRB(23, 5, 23, 5),
          callback: member == null || !_canSave
              ? null
              : () {
                  saveHost(member);
                  setState(() {
                    _canSave = false;
                  });
                },
        ),
        const SizedBox(width: 285),
      ]),
    );
  }

  List<Widget> _noHost() {
    return [_noHostDescription(), _Avatar(image: widget._noHostAvatar)];
  }

  List<Widget> _withHost(final Member member) {
    return [_description(member), _Avatar(image: member.avatar)];
  }

  Widget _noHostDescription() {
    final String from = _from();
    final String until = _until();

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: HostTitle("You don't have a host yet"),
          ),
          Row(children: [
            DateWidget("Find a new host from ", "$from"),
            const SizedBox(width: 5),
            DateWidget("until  ", "$until"),
          ]),
        ]);
  }

  Widget _description(final Member member) {
    final String from = _from();
    final String until = _until();

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: HostTitle("Hi, I am ${member.name}"),
          ),
          Row(children: [
            DateWidget("I am your host from ", "$from"),
            const SizedBox(width: 5),
            DateWidget("until  ", "$until"),
          ]),
        ]);
  }

  String _from() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  String _until() {
    final DateTime now = DateTime.now().add(const Duration(days: 7));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }
}


*/
