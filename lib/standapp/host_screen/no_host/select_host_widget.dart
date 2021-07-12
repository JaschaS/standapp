import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_fonts.dart';
import 'avatar_tile_widget.dart';
import 'avatar_widget.dart';

class NoHostWidget extends _BaseSelectWidget {
  NoHostWidget({
    DateTime? start,
    DateTime? end,
  }) : super(
          title: "No host",
          avatarTitle: "You don't have a host",
          avatar: const Avatar(),
          start: start,
          end: end,
        );

  @override
  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      child: Row(
        children: [
          PrimaryAppButton(
            title: "Find new Host",
            callback: () {},
          )
        ],
      ),
    );
  }
}

class CurrentHostWidget extends _BaseSelectWidget {
  CurrentHostWidget({
    String? title,
    Avatar? avatar,
    DateTime? start,
    DateTime? end,
  }) : super(
          title: title,
          avatarTitle: "I am your host",
          avatar: avatar,
          start: start,
          end: end,
        );

  @override
  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      child: Row(
        children: [
          PrimaryAppButton(
            title: "Find new Host",
          )
        ],
      ),
    );
  }
}

class SelectDateWidget extends _BaseSelectWidget {
  SelectDateWidget({DateCallback? onStartChange, DateCallback? onEndChange})
      : super(
          title: "Find a host",
          onStartChange: onStartChange,
          onEndChange: onEndChange,
        );

  @override
  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      child: Row(
        children: [
          PrimaryAppButton(
            title: "Continue",
            callback: () {},
          ),
          const SizedBox(
            width: 12,
          ),
          TextAppButton(
            callback: () {},
            title: "Cancel",
          )
        ],
      ),
    );
  }
}

class SelectHostWidget extends _BaseSelectWidget {
  SelectHostWidget({
    String? title,
    Avatar? avatar,
    DateTime? start,
    DateTime? end,
  }) : super(
          title: title,
          avatarTitle: "Suggested host",
          avatar: avatar,
          start: start,
          end: end,
        );

  @override
  Widget _buttonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      child: Row(
        children: [
          PrimaryAppButton(
            title: "Confirm host",
            callback: () {},
          ),
          const SizedBox(
            width: 12,
          ),
          SecondaryAppButton(
            title: "Search again",
            callback: () {},
          ),
          const SizedBox(
            width: 12,
          ),
          TextAppButton(
            callback: () {},
            title: "Cancel",
          )
        ],
      ),
    );
  }
}

abstract class _BaseSelectWidget extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  final String? title;
  final String? avatarTitle;
  final Avatar? avatar;
  final DateCallback? onStartChange;
  final DateCallback? onEndChange;

  _BaseSelectWidget({
    this.start,
    this.end,
    this.title,
    this.avatarTitle,
    this.avatar,
    this.onStartChange,
    this.onEndChange,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 867,
        height: 275,
        child: Column(
          children: [
            _header(),
            AvatarTile(
              avatar: this.avatar,
              start: this.start,
              end: this.end,
              onStartChange: this.onStartChange,
              onEndChange: this.onEndChange,
              title: _avatarTitle(),
            ),
            _buttonBar()
          ],
        ),
      ),
    );
  }

  Widget _avatarTitle() {
    return Text(
      this.avatarTitle ?? "Select time",
      style: const TextStyle(
        fontSize: AppFonts.h5,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        this.title ?? "",
        style: AppFonts.textStyleWithSize(AppFonts.h2, weight: FontWeight.bold),
      ),
    );
  }

  Widget _buttonBar();
}

class _tmp extends StatefulWidget {
  final DateTime? start;
  final DateTime? end;
  final String? title;
  final Avatar? avatar;

  _tmp({this.start, this.end, this.title, this.avatar});

  @override
  State<StatefulWidget> createState() => _BaseSelectState();
}

class _BaseSelectState extends State<_tmp> {
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
            _header(),
            AvatarTile(
              avatar: widget.avatar,
              start: _start,
              end: _end,
              title: _avatarTitle(),
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

  Widget _avatarTitle() {
    return Text(
      "Select time",
      style: AppFonts.textStyleWithSize(AppFonts.h5, weight: FontWeight.bold),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.title ?? "",
        style: AppFonts.textStyleWithSize(AppFonts.h2, weight: FontWeight.bold),
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
