import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_buttons.dart';
import 'package:standapp/standapp/standapp_colors.dart';
import 'package:standapp/standapp/standapp_fonts.dart';
import 'package:standapp/standapp/widgets/host_screen/avatar_tile_widget.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp() : super(key: const Key("TestApp"));

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: "StandUp-Host",
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: AvatarTile(
            title: _header(),
            description: Text(
              "I am your next host",
              style: AppFonts.textStyleWithSize(
                AppFonts.h5,
                weight: FontWeight.bold,
              ),
            ),
            primary: PrimaryAppButton(
              title: "Confirm host",
              callback: () {},
            ),
            secondary: SecondaryAppButton(
              title: "Search again",
              callback: () {},
            ),
            alternate: TextAppButton(
              callback: () {},
              title: "Cancel",
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Text(
      "Hi, I am Jascha",
      style: AppFonts.textStyleWithSize(
        AppFonts.h2,
        weight: FontWeight.bold,
        color: AppColors.standardBlue,
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar() : super(key: const Key("Calendar"));

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Container(
        width: 460,
        height: 250,
        color: Colors.red,
        child: Column(
          children: [
            _header(_currentDate),
          ],
        ),
      ),
    );
  }

  Widget _header(final DateTime date) {
    return Row(
      children: [
        Text(
          "${_month(date)} ${date.year}",
          style: AppFonts.textStyleWithSize(
            AppFonts.h3,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: _onPreviousMonth,
          child: const Icon(Icons.chevron_left),
        ),
        TextButton(
          onPressed: _onToday,
          child: const Text("Today"),
        ),
        TextButton(
          onPressed: _onNextMonth,
          child: const Icon(Icons.chevron_right),
        )
      ],
    );
  }

  void _onToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _onPreviousMonth() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month - 1,
        _currentDate.day,
      );
    });
  }

  void _onNextMonth() {
    setState(() {
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + 1,
        _currentDate.day,
      );
    });
  }

  String _month(final DateTime date) {
    switch (date.month) {
      case DateTime.january:
        return "January";
      case DateTime.february:
        return "February";
      case DateTime.march:
        return "March";
      case DateTime.april:
        return "April";
      case DateTime.may:
        return "May";
      case DateTime.june:
        return "June";
      case DateTime.july:
        return "July";
      case DateTime.august:
        return "August";
      case DateTime.september:
        return "September";
      case DateTime.october:
        return "October";
      case DateTime.november:
        return "November";
      case DateTime.december:
        return "December";
      default:
        return "ERROR";
    }
  }
}
