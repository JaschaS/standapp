import 'package:flutter/material.dart';

import 'date_widget.dart';
import 'host_button.dart';

class HostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 30),
            child: Image(
              image: AssetImage('images/Avatar18.png'),
              fit: BoxFit.cover,
            ),
          ),
          _Title("Hi, I am Jascha"),
          const SizedBox(height: 25),
          _SubTitle("I am your Host"),
          DateWidget("from ", "24.05.2021"),
          DateWidget("until  ", "28.05.2021"),
          const SizedBox(height: 50),
          HostButton("New List", EdgeInsets.fromLTRB(0, 5, 0, 5)),
          const SizedBox(height: 10),
          HostButton("Next", EdgeInsets.fromLTRB(23, 5, 23, 5)),
          const SizedBox(height: 10),
          HostButton("Save", EdgeInsets.fromLTRB(23, 5, 23, 5)),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String _text;

  _Title(this._text);

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Text(
        _text,
        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  final String _text;

  _SubTitle(this._text);

  @override
  Widget build(final BuildContext context) {
    return Center(child: Text(_text, style: TextStyle(fontSize: 16)));
  }
}
