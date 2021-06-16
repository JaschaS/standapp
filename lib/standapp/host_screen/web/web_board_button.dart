import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef StringCallback = void Function(String);

class WebBoardButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final IconData _icon;
  final VoidCallback? _onInfo;
  final VoidCallback? _onRemove;

  WebBoardButton(this._text,
      {color = Colors.white,
      icon = Icons.person,
      VoidCallback? onInfo,
      VoidCallback? onRemove})
      : this._color = color,
        this._icon = icon,
        this._onInfo = onInfo,
        this._onRemove = onRemove;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 210,
      child: Card(
        color: this._color,
        child: ListTile(
          title: Row(
            children: [
              Icon(
                this._icon,
                color: AppColors.darkGray,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(this._text),
            ],
          ),
          trailing: TextButton(
            onPressed: _onRemove,
            child: Icon(
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
