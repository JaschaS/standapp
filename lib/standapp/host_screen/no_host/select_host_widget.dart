import 'package:flutter/material.dart';
import 'avatar_tile_widget.dart';

class SelectHostWidget extends StatefulWidget {
  final DateTime? start;
  final DateTime? end;

  SelectHostWidget({this.start, this.end});

  @override
  State<StatefulWidget> createState() => _SelectHostState();
}

class _SelectHostState extends State<SelectHostWidget> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    _start = widget.start ?? _generateStartTime();
    _end = widget.end ?? _start.add(Duration(days: 4));

    super.initState();
  }

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
              start: _start,
              end: _end,
              title: _title(),
              onStartChange: _onStartChange,
              onEndChange: _onEndChange,
            ),
          ],
        ),
      ),
    );
  }

  void _onStartChange(final DateTime date) {
    setState(() {
      _start = date;
    });
  }

  void _onEndChange(final DateTime date) {
    setState(() {
      _end = date;
    });
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

  DateTime _generateStartTime() {
    final today = DateTime.now();

    switch (today.weekday) {
      case DateTime.monday:
        return today;
      case DateTime.tuesday:
        return today.add(Duration(days: 6));
      case DateTime.wednesday:
        return today.add(Duration(days: 5));
      case DateTime.thursday:
        return today.add(Duration(days: 4));
      case DateTime.friday:
        return today.add(Duration(days: 3));
      case DateTime.saturday:
        return today.add(Duration(days: 2));
      case DateTime.sunday:
        return today.add(Duration(days: 1));
      default:
        return today;
    }
  }
}

// Header
// AvatarTile
// bottom bar
