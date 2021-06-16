import 'package:flutter/material.dart';
import 'package:standapp/standapp/home_screen/board_button.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef StringCallback = void Function(String);

class MemberWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<MemberWidget> {
  List<String> _allMembers = [];

  void _addMember() {}

  void _addGroup() {}

  @override
  Widget build(final BuildContext context) {
    return Container(
        color: AppColors.blue,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            _Title(
              addMember: this._addMember,
              addGroup: this._addGroup,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: 0,
              itemBuilder: (context, index) {
                return BoardButton(
                  "Jascha",
                  icon: Icons.folder,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
            ),
            const SizedBox(height: 25),
          ],
        ));
  }
}

class _Title extends StatelessWidget {
  final VoidCallback? _addMember;
  final VoidCallback? _addGroup;

  _Title({VoidCallback? addMember, VoidCallback? addGroup})
      : this._addMember = addMember,
        this._addGroup = addGroup;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Text(
          "Members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return AddMemberModal((value) {});
                  });
            },
            child: Icon(
              Icons.person_add,
              color: AppColors.darkGray,
            )),
        TextButton(
            onPressed: () {},
            child: Icon(
              Icons.group_add,
              color: AppColors.darkGray,
            ))
      ],
    );
  }
}

class AddMemberModal extends StatefulWidget {
  final StringCallback _callback;
  final String _existingText;

  AddMemberModal(this._callback, {existingText: ""})
      : this._existingText = existingText;

  @override
  State<StatefulWidget> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMemberModal> {
  late TextEditingController _controller;
  bool _validText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget._existingText.isNotEmpty) {
      _controller.text = widget._existingText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCreate() {
    if (this._controller.text.isEmpty) {
      setState(() {
        this._validText = false;
      });
    } else {
      widget._callback(_controller.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                Spacer(),
                Text(
                  "New Member",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                  onPressed: _onCreate,
                  child: Text("Create"),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
                controller: this._controller,
                decoration: new InputDecoration(
                    errorText: this._validText ? null : "Please enter a name",
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "New member name - e.g. Marcus")),
          )
        ],
      ),
    );
  }
}
