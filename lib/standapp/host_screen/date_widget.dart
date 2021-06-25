import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class DateWidget extends StatefulWidget {
  final String _text;
  final String _startDate;

  DateWidget(this._text, this._startDate);

  @override
  State<StatefulWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late String _date;

  @override
  void initState() {
    _date = widget._startDate;
    super.initState();
  }

  void _onPress(final BuildContext context) async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    final DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: AppColors.darkGray,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.red,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: formatter.parseUTC(_date),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (newDate != null) {
      setState(() {
        _date = formatter.format(newDate);
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget._text, style: TextStyle(fontSize: 16)),
          _timeButton(context),
        ],
      ),
    );
  }

  Widget _timeButton(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(232, 232, 232, 1),
      ),
      onPressed: () {
        _onPress(context);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 5, top: 5),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              color: Colors.black,
            ),
            const SizedBox(width: 5),
            Text(
              this._date,
              style: TextStyle(fontSize: 16, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
