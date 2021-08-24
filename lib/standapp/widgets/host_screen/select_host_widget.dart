import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/services/http_service.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';
import '../../models/member_model.dart';
import 'avatar_tile_widget.dart';
import 'avatar_widget.dart';
import 'loading_host_widget.dart';

enum _HostState { SELECT_DATE, SELECT_HOST, SHOW_HOST, LOADING_STATE }

class HostWidget extends StatefulWidget {
  final User? user;
  final Future<Member>? currentHost;

  HostWidget({this.user, this.currentHost});

  @override
  State<StatefulWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends State<HostWidget> {
  _HostState _showState = _HostState.SHOW_HOST;
  late DateTime _start = DateTime.now();
  late DateTime _end = DateTime.now();
  late Future<Member> _suggestion;
  late Future<Member> _host;

  @override
  void initState() {
    super.initState();

    _host = widget.currentHost ?? HttpService.getCurrentHost(widget.user!);
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

  void _searchAgain(final Member member) {
    setState(() {
      this._suggestion =
          HttpService.getRecommendationWithoutMember(widget.user!, member);
    });
  }

  void _saveHost(final Member newHost) async {
    newHost.startDate = _start.toIso8601String();
    newHost.endDate = _end.toIso8601String();

    HttpService.postHost(widget.user!, newHost).then((value) {
      setState(() {
        _host = HttpService.getCurrentHost(widget.user!);
        this._showState = _HostState.SHOW_HOST;
      });
    });

    setState(() {
      this._showState = _HostState.LOADING_STATE;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.weisser_als_weiss,
      child: FutureBuilder<Member>(
        future: _host,
        builder: (context, currentHost) {
          if (currentHost.connectionState != ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.only(bottom: 92),
              child: LoadingHostWidget(),
            );
          }

          if (currentHost.hasData) {
            return Padding(
              padding: EdgeInsets.only(bottom: 92),
              child: Center(
                child: _widgetForState(currentHost),
              ),
            );
          }

          if (currentHost.hasError) {
            return _showError(currentHost);
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 92),
            child: LoadingHostWidget(),
          );
        },
      ),
    );
  }

  Widget _widgetForState(final AsyncSnapshot<Member> currentHost) {
    switch (this._showState) {
      case _HostState.SHOW_HOST:
        final hostData = currentHost.data!;
        if (hostData.isEmpty()) {
          return _noHostWidget();
        }

        return _currentHostWidget(hostData);
      case _HostState.SELECT_DATE:
        return _selectDateWidget();
      case _HostState.SELECT_HOST:
        return FutureBuilder<Member>(
          future: this._suggestion,
          builder: (context, suggestion) {
            if (suggestion.connectionState != ConnectionState.done) {
              return LoadingHostWidget();
            }

            if (suggestion.hasError) {
              return _showError(suggestion);
            }

            if (suggestion.hasData) {
              return _selectHostWidget(suggestion.data!);
            }

            return LoadingHostWidget();
          },
        );
      case _HostState.LOADING_STATE:
        return LoadingHostWidget();
      default:
        return _noHostWidget();
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

  Widget _createTitle(final String title) {
    return Text(
      title,
      style: AppFonts.textStyleWithSize(
        AppFonts.h2,
        weight: FontWeight.bold,
        color: AppColors.standard_blue,
      ),
    );
  }

  Widget _createDescription(final String text) {
    return Text(
      text,
      style: AppFonts.textStyleWithSize(
        AppFonts.h5,
        weight: FontWeight.bold,
      ),
    );
  }

  Widget _noHostWidget() {
    return AvatarTile(
      title: _createTitle("No host"),
      description: _createDescription("You don't have a host"),
      avatar: const Avatar(),
      primary: PrimaryAppButton(
        title: "Find a Host",
        callback: this._selectHost,
      ),
    );
  }

  Widget _currentHostWidget(final Member host) {
    return AvatarTile(
      title: _createTitle("Hi, I am ${host.name}"),
      description: _createDescription("I am your host"),
      avatar: Avatar(
        image: host.avatar,
      ),
      start: DateTime.parse(host.startDate!),
      end: DateTime.parse(host.endDate!),
      primary: PrimaryAppButton(
        title: "Find new Host",
        callback: this._selectHost,
      ),
    );
  }

  Widget _selectDateWidget() {
    return AvatarTile(
      title: _createTitle("Find a host"),
      description: _createDescription("select a time range"),
      avatar: const Avatar(),
      onStartChange: _onStartChange,
      onEndChange: _onEndChange,
      start: this._start,
      end: this._end,
      primary: PrimaryAppButton(
        title: "Continue",
        callback: this._nextSelectHost,
      ),
      alternate: TextAppButton(
        callback: this._goBackToShowHost,
        title: "Cancel",
      ),
    );
  }

  Widget _selectHostWidget(final Member host) {
    return AvatarTile(
      title: _createTitle("It is ${host.name}!"),
      description: _createDescription("Suggested host"),
      avatar: Avatar(
        image: host.avatar,
      ),
      start: this._start,
      end: this._end,
      primary: PrimaryAppButton(
        title: "Confirm Host",
        callback: () => _saveHost(host),
      ),
      secondary: SecondaryAppButton(
        title: "Search again",
        callback: () => _searchAgain(host),
      ),
      alternate: TextAppButton(
        callback: this._goBackToSelectDate,
        title: "Cancel",
      ),
    );
  }
}
