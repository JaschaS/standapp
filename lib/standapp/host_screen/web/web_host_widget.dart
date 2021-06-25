import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_avatars.dart';

import '../date_widget.dart';
import '../host_button.dart';
import 'package:intl/intl.dart';

import '../member_model.dart';

class WebNoHostWidget extends _WebHost {
  final String _noHostAvatar;

  WebNoHostWidget({String? noHostAvatar, VoidCallback? findHost})
      : this._noHostAvatar = noHostAvatar ?? AvatarsImages.randomBlackAvatar(),
        super(findHost: findHost);

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
}

class WebHostWidget extends _WebHost {
  final Member _member;

  WebHostWidget(Member member, {VoidCallback? findHost, VoidCallback? saveHost})
      : this._member = member,
        super(findHost: findHost, saveHost: saveHost);

  @override
  String _from() {
    return _member.startDate ?? "xx-xx-xxxx";
  }

  @override
  String _until() {
    return _member.endDate ?? "xx-xx-xxxx";
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
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: SizedBox(
        width: 650,
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

  String _from();

  String _until();

  String _avatar();

  Widget _hostWidget() {
    final String from = _from();
    final String until = _until();

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
                DateWidget(_fromTitle(), "$from"),
                const SizedBox(width: 5),
                DateWidget("until  ", "$until"),
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
