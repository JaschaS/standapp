import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef StringCallback = void Function(String);

class BoardButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final IconData _icon;
  final StringCallback? _onDelete;
  final StringCallback? _onInfo;

  BoardButton(this._text,
      {color = Colors.white,
      icon = Icons.person,
      StringCallback? onDelete,
      StringCallback? onInfo})
      : this._color = color,
        this._icon = icon,
        this._onDelete = onDelete,
        this._onInfo = onInfo;

  @override
  Widget build(final BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        key: Key(_text),
        child: Ink(
          child: SizedBox(
            width: 210,
            child: ListTile(
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.darkGray,
              ),
              onTap: () {
                /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HostScreenWidget()),
              );*/
              },
              tileColor: this._color,
              leading: Icon(this._icon),
              title: Text(this._text),
            ),
          ),
        ),
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {},
        ),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: AppColors.lightGray,
            foregroundColor: Colors.white,
            icon: Icons.info,
            onTap: () {
              this._onInfo!(this._text);
            },
          ),
          IconSlideAction(
            color: AppColors.red,
            icon: Icons.delete,
            onTap: () {
              this._onDelete!(this._text);
            },
          ),
        ],
      ),
    );
  }
}
