import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/host_button.dart';

import '../../standapp_colors.dart';

class NoHostWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 555,
        height: 190,
        child: Card(
          elevation: 0,
          child: Row(
            children: [
              _Avatar(
                image: "images/Anonymous.png",
              ),
              const SizedBox(
                width: 109,
              ),
              Column(
                children: [
                  const Text(
                    "You don't have a \nhost, yet",
                    style: const TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Container(
                    width: 250,
                    height: 56,
                    child: _HostButton(
                      "Find a host",
                      callback: () {},
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HostButton extends StatelessWidget {
  final String _text;
  final EdgeInsets _padding;
  final VoidCallback? _callback;

  _HostButton(this._text, {VoidCallback? callback, padding = EdgeInsets.zero})
      : this._callback = callback,
        this._padding = padding;

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: AppColors.red),
      onPressed: this._callback,
      child: Padding(
        padding: this._padding,
        child: Text(
          this._text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String _image;

  _Avatar({String image = 'images/Avatar20-1.png'}) : this._image = image;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Image(
        image: AssetImage(_image),
        fit: BoxFit.cover,
      ),
    );
  }
}
