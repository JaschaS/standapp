import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_avatars.dart';

import '../date_widget.dart';
import '../host_button.dart';

import '../member_model.dart';

class WebNoHostWidget extends _WebHost {
  final String _noHostAvatar;

  WebNoHostWidget({String? noHostAvatar, VoidCallback? findHost})
      : this._noHostAvatar = noHostAvatar ?? AvatarsImages.randomBlackAvatar(),
        super(findHost: findHost, width: 675, clicakble: false);

  @override
  DateTime _from() {
    return DateTime.now();
  }

  @override
  DateTime _until() {
    return DateTime.now().add(Duration(days: 1));
  }

  @override
  String _fromTitle() {
    return "Find a new host from ";
  }

  @override
  String _hostName() {
    return "You don't have a host yet";
  }

  @override
  String _avatar() {
    return _noHostAvatar;
  }

  @override
  void _fromCallback(DateTime newFrom) {}

  @override
  void _untilCallback(DateTime newUntil) {}
}

class WebHostWidget extends _WebHost {
  final Member _member;

  WebHostWidget(Member member, {VoidCallback? findHost, VoidCallback? saveHost})
      : this._member = member,
        super(findHost: findHost, saveHost: saveHost);

  @override
  DateTime _from() {
    if (_member.startDate == null) return DateTime.now();

    return DateTime.parse(_member.startDate!);
  }

  @override
  DateTime _until() {
    if (_member.startDate == null) return DateTime.now().add(Duration(days: 1));

    return DateTime.parse(_member.endDate!);
  }

  @override
  String _fromTitle() {
    return "I am your host from ";
  }

  @override
  String _hostName() {
    return "Hi, I am ${_member.name}";
  }

  @override
  String _avatar() {
    return _member.avatar;
  }

  @override
  void _fromCallback(DateTime newFrom) {
    _member.startDate = newFrom.toIso8601String().split("T")[0];
  }

  @override
  void _untilCallback(DateTime newUntil) {
    _member.endDate = newUntil.toIso8601String().split("T")[0];
  }
}

abstract class _WebHost extends StatelessWidget {
  final VoidCallback? _findHost;
  final VoidCallback? _saveHost;
  final double _width;
  final bool _isClickable;

  _WebHost(
      {VoidCallback? findHost,
      VoidCallback? saveHost,
      double width = 650,
      bool clicakble = true})
      : this._findHost = findHost,
        this._saveHost = saveHost,
        this._width = width,
        this._isClickable = clicakble;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: SizedBox(
        width: _width,
        child: Card(
          elevation: 0,
          child: Column(
            children: [
              _hostWidget(),
              const SizedBox(
                height: 15,
              ),
              _buttonBar(),
            ],
          ),
        ),
      ),
    );
  }

  String _hostName();

  String _fromTitle();

  DateTime _from();

  DateTime _until();

  String _avatar();

  void _fromCallback(final DateTime newFrom);

  void _untilCallback(final DateTime newUntil);

  Widget _hostWidget() {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hostName(),
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                DateWidget(
                  _fromTitle(),
                  _from(),
                  callback: _isClickable ? _fromCallback : null,
                ),
                const SizedBox(width: 5),
                DateWidget(
                  "until  ",
                  _until(),
                  callback: _isClickable ? _untilCallback : null,
                ),
              ],
            )
          ],
        ),
        Spacer(),
        _Avatar(image: _avatar())
      ],
    );
  }

  Widget _buttonBar() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String _image;

  _Avatar({String image = 'images/Avatar20-1.png'}) : this._image = image;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image(
        image: AssetImage(_image),
        fit: BoxFit.cover,
      ),
    );
  }
}
