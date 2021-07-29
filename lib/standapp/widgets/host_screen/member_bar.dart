import 'package:flutter/material.dart';

import '../../standapp_colors.dart';

typedef ContextCallback = void Function(BuildContext);

class MemberBar extends StatelessWidget {
  final VoidCallback? addMember;

  MemberBar({this.addMember});

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Team members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 600,
        ),
        TextButton(
          onPressed: this.addMember,
          child: Icon(
            Icons.person_add,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}
