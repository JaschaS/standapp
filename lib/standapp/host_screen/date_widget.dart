import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:standapp/standapp/standapp_colors.dart';

typedef DateTimeCallback = void Function(DateTime);

class DateWidget extends StatefulWidget {
  final String _displayText;
  final DateTime _startDate;
  final DateTimeCallback? _callback;

  DateWidget(this._displayText, this._startDate, {DateTimeCallback? callback})
      : this._callback = callback;

  @override
  State<StatefulWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late DateTime _date;
  final DateFormat _formatter = DateFormat.yMMMMd('en_US');

  @override
  void initState() {
    _date = widget._startDate;
    super.initState();
  }

  void _onPress(final BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            primaryColor: AppColors.red,
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
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (newDate != null) {
      setState(() {
        _date = newDate;
        if (widget._callback != null) {
          widget._callback!(newDate);
        }
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
          Text(widget._displayText, style: TextStyle(fontSize: 16)),
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
      onPressed: widget._callback != null
          ? () {
              _onPress(context);
            }
          : null,
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
              _formatter.format(_date),
              style: TextStyle(fontSize: 16, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
