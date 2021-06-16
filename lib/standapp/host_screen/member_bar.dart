import 'package:flutter/material.dart';

import '../standapp_colors.dart';

typedef ContextCallback = void Function(BuildContext);

class MemberBar extends StatelessWidget {
  final ContextCallback? _addMember;
  final ContextCallback? _addGroup;

  MemberBar({ContextCallback? addMember, ContextCallback? addGroup})
      : this._addMember = addMember,
        this._addGroup = addGroup;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 485,
        ),
        TextButton(
            onPressed: () {
              this._addMember!(context);
            },
            child: Icon(
              Icons.person_add,
              color: AppColors.darkGray,
            )),
        /*TextButton(
            onPressed: () {
              this._addGroup!(context);
            },
            child: Icon(
              Icons.group_add,
              color: AppColors.darkGray,
            ))*/
      ],
    );
  }
}
