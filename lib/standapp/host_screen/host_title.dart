import 'package:flutter/material.dart';

class HostTitle extends StatelessWidget {
  final String _text;

  HostTitle(this._text);

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

class SubTitleWidget extends StatelessWidget {
  final String _text;

  SubTitleWidget(this._text);

  @override
  Widget build(final BuildContext context) {
    return Center(child: Text(_text, style: TextStyle(fontSize: 16)));
  }
}
