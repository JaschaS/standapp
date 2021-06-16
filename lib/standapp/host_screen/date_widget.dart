import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final String _text;
  final String _date;

  DateWidget(this._text, this._date);

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(this._text, style: TextStyle(fontSize: 16)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(232, 232, 232, 1),
            ),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(Icons.date_range),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(this._date, style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
