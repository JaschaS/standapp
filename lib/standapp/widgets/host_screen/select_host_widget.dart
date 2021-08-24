import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/clients/backend_client.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';
import '../../models/member_model.dart';
import 'avatar_tile_widget.dart';
import 'avatar_widget.dart';
import 'loading_host_widget.dart';

enum _HostState { selectDate, selectHost, showHost, loadingState }

class HostWidget extends StatefulWidget {
  final User? user;
  final Future<Member>? currentHost;

  const HostWidget({
    this.user,
    this.currentHost,
  }) : super(key: const Key("HostWidget"));

  @override
  State<StatefulWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends State<HostWidget> {
  _HostState _showState = _HostState.showHost;
  late DateTime _start = DateTime.now();
  late DateTime _end = DateTime.now();
  late Future<Member> _suggestion;
  late Future<Member> _host;

  @override
  void initState() {
    super.initState();

    _host = widget.currentHost ?? BackendClient.getCurrentHost(widget.user!);
    _start = _calculateStartDate();
    _end = _calculateEndDate();
  }

  void _selectHost() {
    setState(() {
      _showState = _HostState.selectDate;
    });
  }

  void _goBackToShowHost() {
    setState(() {
      _showState = _HostState.showHost;
    });
  }

  void _goBackToSelectDate() {
    setState(() {
      _showState = _HostState.selectDate;
    });
  }

  void _onStartChange(final DateTime dateTime) {
    setState(() {
      _start = dateTime;
    });
  }

  void _onEndChange(final DateTime dateTime) {
    setState(() {
      _end = dateTime;
    });
  }

  void _nextSelectHost() {
    setState(() {
      _showState = _HostState.selectHost;
      _suggestion = BackendClient.getRecommendation(widget.user!);
    });
  }

  void _searchAgain(final Member member) {
    setState(() {
      _suggestion =
          BackendClient.getRecommendationWithoutMember(widget.user!, member);
    });
  }

  void _saveHost(final Member newHost) async {
    newHost.startDate = _start.toIso8601String();
    newHost.endDate = _end.toIso8601String();

    BackendClient.postHost(widget.user!, newHost).then((value) {
      setState(() {
        _host = BackendClient.getCurrentHost(widget.user!);
        _showState = _HostState.showHost;
      });
    });

    setState(() {
      _showState = _HostState.loadingState;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.weisserAlsWeiss,
      child: FutureBuilder<Member>(
        future: _host,
        builder: (context, currentHost) {
          if (currentHost.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 92),
              child: LoadingHostWidget(),
            );
          }

          if (currentHost.hasData) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 92),
              child: Center(
                child: _widgetForState(currentHost),
              ),
            );
          }

          if (currentHost.hasError) {
            return _showError(currentHost);
          }

          return const Padding(
            padding: EdgeInsets.only(bottom: 92),
            child: LoadingHostWidget(),
          );
        },
      ),
    );
  }

  Widget _widgetForState(final AsyncSnapshot<Member> currentHost) {
    switch (_showState) {
      case _HostState.showHost:
        final hostData = currentHost.data!;
        if (hostData.isEmpty()) {
          return _noHostWidget();
        }

        return _currentHostWidget(hostData);
      case _HostState.selectDate:
        return _selectDateWidget();
      case _HostState.selectHost:
        return FutureBuilder<Member>(
          future: _suggestion,
          builder: (context, suggestion) {
            if (suggestion.connectionState != ConnectionState.done) {
              return const LoadingHostWidget();
            }

            if (suggestion.hasError) {
              return _showError(suggestion);
            }

            if (suggestion.hasData) {
              return _selectHostWidget(suggestion.data!);
            }

            return const LoadingHostWidget();
          },
        );
      case _HostState.loadingState:
        return const LoadingHostWidget();
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
        return today.add(const Duration(days: 6));
      case DateTime.wednesday:
        return today.add(const Duration(days: 5));
      case DateTime.thursday:
        return today.add(const Duration(days: 4));
      case DateTime.friday:
        return today.add(const Duration(days: 3));
      case DateTime.saturday:
        return today.add(const Duration(days: 2));
      case DateTime.sunday:
        return today.add(const Duration(days: 1));
      default:
        return today;
    }
  }

  DateTime _calculateEndDate() {
    return _start.add(const Duration(days: 4));
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
        color: AppColors.standardBlue,
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
        callback: _selectHost,
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
        callback: _selectHost,
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
      start: _start,
      end: _end,
      primary: PrimaryAppButton(
        title: "Continue",
        callback: _nextSelectHost,
      ),
      alternate: TextAppButton(
        callback: _goBackToShowHost,
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
      start: _start,
      end: _end,
      primary: PrimaryAppButton(
        title: "Confirm Host",
        callback: () => _saveHost(host),
      ),
      secondary: SecondaryAppButton(
        title: "Search again",
        callback: () => _searchAgain(host),
      ),
      alternate: TextAppButton(
        callback: _goBackToSelectDate,
        title: "Cancel",
      ),
    );
  }
}
