import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef StringCallback = void Function(String);

class WebBoardButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final IconData _icon;
  final VoidCallback? _onInfo;
  final VoidCallback? _onRemove;

  const WebBoardButton(this._text,
      {color = Colors.white,
      icon = Icons.person,
      VoidCallback? onInfo,
      VoidCallback? onRemove})
      : _color = color,
        _icon = icon,
        _onInfo = onInfo,
        _onRemove = onRemove,
        super(key: const Key("WebBoardButton"));

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 259,
      child: Card(
        color: _color,
        child: ListTile(
          title: Row(
            children: [
              Icon(
                _icon,
                color: AppColors.darkGray,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(_text),
            ],
          ),
          trailing: TextButton(
            onPressed: _onRemove,
            child: const Icon(
              Icons.close,
              size: 15,
              color: AppColors.darkGray,
            ),
          ),
          onTap: _onInfo,
        ),
      ),
    );
  }
}
