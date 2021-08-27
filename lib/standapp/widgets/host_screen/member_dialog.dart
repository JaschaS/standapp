import 'package:flutter/material.dart';

import '../../standapp_avatars.dart';
import '../../models/member_model.dart';

typedef MemberCallback = void Function(Member?, Member);

class MemberDialog extends StatefulWidget {
  final MemberCallback? _callback;
  final Member? _existingMember;
  final String _okText;

  const MemberDialog({
    MemberCallback? callback,
    Member? existingMember,
    okText = "",
  })  : _callback = callback,
        _existingMember = existingMember,
        _okText = okText,
        super(key: const Key("WebDialog"));

  @override
  State<StatefulWidget> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  late TextEditingController _controller;
  bool _validText = true;
  String _currentAvatar = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    final member = widget._existingMember;
    if (member != null) {
      final name = member.name;
      final avatar = member.avatar;

      if (name.isNotEmpty) _controller.text = name;
      if (avatar.isNotEmpty) {
        _currentAvatar = avatar;
      } else {
        _currentAvatar = AvatarsImages.randomAvatar();
      }
    } else {
      _currentAvatar = AvatarsImages.randomAvatar();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCreate() {
    if (_controller.text.isEmpty) {
      setState(() {
        _validText = false;
      });
    } else {
      final member = _createMember();
      widget._callback!(widget._existingMember, member);
      Navigator.pop(context);
    }
  }

  void _onAvatarChange(final String avatar) {
    setState(() {
      _currentAvatar = avatar;
    });
  }

  Member _createMember() {
    return Member(
      name: _controller.text,
      avatar: _currentAvatar,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final avatars = [];
    avatars.addAll(AvatarsImages.imagesColored);

    return SimpleDialog(
      title: _buttonBar(),
      children: [
        _Avatar(
          imageName: _currentAvatar,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              errorText: _validText ? null : "Please enter a name",
              hintText: "enter new Member name",
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 11,
                top: 11,
                right: 15,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
          alignment: Alignment.center,
          width: 225,
          height: 190,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 5,
              children: List.generate(avatars.length, (index) {
                return _Avatar(
                  width: 65,
                  height: 65,
                  imageName: avatars[index],
                  callback: () {
                    _onAvatarChange(avatars[index]);
                  },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('cancel'),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: const Text(
            "New Member",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SimpleDialogOption(
          onPressed: _onCreate,
          child: Text(widget._okText),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final double _width;
  final double _height;
  final String _imageName;
  final VoidCallback? _callback;

  const _Avatar(
      {width = 125,
      height = 125,
      imageName = 'images/Avatar18.png',
      VoidCallback? callback})
      : _height = height,
        _width = width,
        _imageName = imageName,
        _callback = callback;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: IconButton(
        hoverColor: Colors.transparent,
        icon: Image(
          image: AssetImage(_imageName),
        ),
        onPressed: _callback,
      ),
    );
  }
}