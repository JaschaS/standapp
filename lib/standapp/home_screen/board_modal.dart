import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

class NewBoardModal extends StatefulWidget {
  final StringCallback _callback;
  final String _existingText;

  NewBoardModal(this._callback, {existingText: ""})
      : this._existingText = existingText;

  @override
  State<StatefulWidget> createState() => _NewBoardState();
}

class _NewBoardState extends State<NewBoardModal> {
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
                  "New Board",
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
                    errorText:
                        this._validText ? null : "Please enter a board name",
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "New board name - e.g. SDC")),
          )
        ],
      ),
    );
  }
}
