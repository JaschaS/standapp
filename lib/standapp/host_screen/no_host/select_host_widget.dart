import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/services/http_service.dart';
import 'package:standapp/standapp/standapp_avatars.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';
import '../background_widget.dart';
import '../member_model.dart';
import 'avatar_tile_widget.dart';
import 'avatar_widget.dart';

enum _HostState { SELECT_DATE, SELECT_HOST, SHOW_HOST }

class HostWidget extends StatefulWidget {
  final User? user;

  HostWidget({this.user});

  @override
  State<StatefulWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends State<HostWidget> {
  _HostState _showState = _HostState.SHOW_HOST;
  late DateTime _start = DateTime.now();
  late DateTime _end = DateTime.now();
  late Future<Member> _currentHost;
  late Future<Member> _suggestion;

  @override
  void initState() {
    super.initState();

    _currentHost = HttpService.getCurrentHost(widget.user!);
    _start = _calculateStartDate();
    _end = _calculateEndDate();
  }

  void _selectHost() {
    setState(() {
      this._showState = _HostState.SELECT_DATE;
    });
  }

  void _goBackToShowHost() {
    setState(() {
      this._showState = _HostState.SHOW_HOST;
    });
  }

  void _goBackToSelectDate() {
    setState(() {
      this._showState = _HostState.SELECT_DATE;
    });
  }

  void _onStartChange(final DateTime dateTime) {
    setState(() {
      this._start = dateTime;
    });
  }

  void _onEndChange(final DateTime dateTime) {
    setState(() {
      this._end = dateTime;
    });
  }

  void _nextSelectHost() {
    setState(() {
      this._showState = _HostState.SELECT_HOST;
      this._suggestion = HttpService.getRecommendation(widget.user!);
    });
  }

  void _searchAgain() {
    setState(() {
      this._suggestion = HttpService.getRecommendation(widget.user!);
    });
  }

  void _saveHost(final Member newHost) async {
    newHost.startDate = _start.toIso8601String();
    newHost.endDate = _end.toIso8601String();
    await HttpService.postHost(widget.user!, newHost);

    setState(() {
      this._currentHost = HttpService.getCurrentHost(widget.user!);
      this._showState = _HostState.SHOW_HOST;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<Member>(
      future: _currentHost,
      builder: (context, currentHost) {
        if (currentHost.connectionState != ConnectionState.done) {
          return _loading();
        }

        if (currentHost.hasData) {
          return _widgetForState(currentHost);
        }

        if (currentHost.hasError) {
          return _showError(currentHost);
        }

        return _loading();
      },
    );
  }

  Widget _widgetForState(final AsyncSnapshot<Member> currentHost) {
    switch (this._showState) {
      case _HostState.SHOW_HOST:
        final hostData = currentHost.data!;
        if (hostData.isEmpty()) {
          return NoHostWidget();
        }

        return CurrentHostWidget(
          title: "Hi, I am ${hostData.name}",
          avatar: Avatar(
            image: AvatarsImages.ginger_freckles,
          ),
          start: DateTime.parse(hostData.startDate!),
          end: DateTime.parse(hostData.endDate!),
          callback: _selectHost,
        );
      case _HostState.SELECT_DATE:
        return SelectDateWidget(
          cancel: _goBackToShowHost,
          onStartChange: _onStartChange,
          onEndChange: _onEndChange,
          next: _nextSelectHost,
          start: _start,
          end: _end,
        );
      case _HostState.SELECT_HOST:
        return FutureBuilder<Member>(
          future: this._suggestion,
          builder: (context, suggestion) {
            if (suggestion.connectionState != ConnectionState.done) {
              return _loading();
            }

            if (suggestion.hasError) {
              return _showError(suggestion);
            }

            if (suggestion.hasData) {
              final suggestionData = suggestion.data!;

              return SelectHostWidget(
                title: "It is ${suggestionData.name}!",
                avatar: Avatar(
                  image: AvatarsImages.ginger_freckles,
                ),
                start: _start,
                end: _end,
                cancel: _goBackToSelectDate,
                searchAgain: _searchAgain,
                confirm: () => _saveHost(suggestionData),
              );
            }

            return _loading();
          },
        );
      default:
        return NoHostWidget();
    }
  }

  DateTime _calculateStartDate() {
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

  DateTime _calculateEndDate() {
    return this._start.add(Duration(days: 4));
  }

  Widget _showError(final AsyncSnapshot<Member?> snapshot) {
    return Center(
      child: Text("${snapshot.error}"),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NoHostWidget extends _BaseSelectWidget {
  final VoidCallback? callback;

  NoHostWidget({
    DateTime? start,
    DateTime? end,
    VoidCallback? callback,
  })  : this.callback = callback,
        super(
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
            callback: this.callback,
          )
        ],
      ),
    );
  }
}

class CurrentHostWidget extends _BaseSelectWidget {
  final VoidCallback? callback;

  CurrentHostWidget({
    String? title,
    Avatar? avatar,
    DateTime? start,
    DateTime? end,
    VoidCallback? callback,
  })  : this.callback = callback,
        super(
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
            callback: this.callback,
          )
        ],
      ),
    );
  }
}

class SelectDateWidget extends _BaseSelectWidget {
  final VoidCallback? cancel;
  final VoidCallback? next;

  SelectDateWidget({
    DateCallback? onStartChange,
    DateCallback? onEndChange,
    VoidCallback? cancel,
    VoidCallback? next,
    DateTime? start,
    DateTime? end,
  })  : this.cancel = cancel,
        this.next = next,
        super(
          title: "Find a host",
          onStartChange: onStartChange,
          onEndChange: onEndChange,
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
            title: "Continue",
            callback: this.next,
          ),
          const SizedBox(
            width: 12,
          ),
          TextAppButton(
            callback: this.cancel,
            title: "Cancel",
          )
        ],
      ),
    );
  }
}

class SelectHostWidget extends _BaseSelectWidget {
  final VoidCallback? cancel;
  final VoidCallback? confirmHost;
  final VoidCallback? searchAgain;

  SelectHostWidget({
    String? title,
    Avatar? avatar,
    DateTime? start,
    DateTime? end,
    VoidCallback? cancel,
    VoidCallback? confirm,
    VoidCallback? searchAgain,
  })  : this.cancel = cancel,
        this.confirmHost = confirm,
        this.searchAgain = searchAgain,
        super(
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
            callback: this.confirmHost,
          ),
          const SizedBox(
            width: 12,
          ),
          SecondaryAppButton(
            title: "Search again",
            callback: this.searchAgain,
          ),
          const SizedBox(
            width: 12,
          ),
          TextAppButton(
            callback: this.cancel,
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
