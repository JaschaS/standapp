import 'package:flutter/material.dart';

import '../../standapp_colors.dart';

typedef ContextCallback = void Function(BuildContext);

class MemberBar extends StatelessWidget {
  final VoidCallback? addMember;

  const MemberBar({this.addMember}) : super(key: const Key("MemberBar"));

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Team members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 600,
        ),
        TextButton(
          onPressed: addMember,
          child: const Icon(
            Icons.person_add,
            color: AppColors.darkGray,
          ),
        ),
      ],
    );
  }
}
