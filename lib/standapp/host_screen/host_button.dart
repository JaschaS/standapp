import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef VoidCallback = void Function();

class HostButton extends StatelessWidget {
  final String _text;
  final EdgeInsets _padding;
  final VoidCallback? _callback;

  HostButton(this._text, this._padding, {VoidCallback? callback})
      : this._callback = callback;

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: AppColors.red),
      onPressed: this._callback,
      child: Padding(
        padding: this._padding,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            this._text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
