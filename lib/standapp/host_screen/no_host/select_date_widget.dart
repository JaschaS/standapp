import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'avatar_tile_widget.dart';

class SelectDateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDateWidget> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 867,
        height: 275,
        child: Column(
          children: [
            AvatarTile(
              title: _title(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Select time",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Header
// AvatarTile
// bottom bars
