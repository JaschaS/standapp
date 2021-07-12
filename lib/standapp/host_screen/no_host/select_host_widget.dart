import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_colors.dart';
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
        color: AppColors.standard_blue,
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(
        this.title ?? "",
        style: AppFonts.textStyleWithSize(
          AppFonts.h2,
          weight: FontWeight.bold,
          color: AppColors.standard_blue,
        ),
      ),
    );
  }

  Widget _buttonBar();
}
