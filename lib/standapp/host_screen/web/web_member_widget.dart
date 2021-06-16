import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/services/http_service.dart';
import 'package:standapp/standapp/host_screen/web/web_board_button.dart';
import 'package:standapp/standapp/host_screen/web/web_dialog.dart';

import '../../standapp_colors.dart';
import '../member_bar.dart';
import '../member_model.dart';
import 'package:http/http.dart' as http;

typedef StringCallback = void Function(String);
typedef MemberListCallback = void Function(Future<List<Member>>);
typedef OldNewCallback = void Function(Member?, Member);

class WebMemberWidget extends StatefulWidget {
  final List<Member>? _members;
  final MemberListCallback? _callback;
  final OldNewCallback? _onInfo;
  final StringCallback? _onRemove;

  WebMemberWidget(
      {List<Member>? members,
      MemberListCallback? callback,
      OldNewCallback? onInfo,
      StringCallback? onRemove})
      : _members = members,
        _callback = callback,
        _onInfo = onInfo,
        _onRemove = onRemove;

  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<WebMemberWidget> {
  List<Member> convertToMember(Iterable json) {
    return List<Member>.from(json.map((model) => Member.fromJson(model)));
  }

  void _addMemberDialog(final BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WebDialog(
            callback: (_, member) {
              final members = HttpService.addMember(member);
              if (widget._members != null) widget._callback!(members);
            },
            okText: "  add ",
          );
        });
  }

  void _onMemberInfo(final BuildContext context, final Member member) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WebDialog(
            okText: "save",
            existingMember: member,
            callback: widget._onInfo,
          );
        });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        color: AppColors.blue,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: MemberBar(
                addMember: _addMemberDialog,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 650,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _generateMemberWidget(widget._members),
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            )
          ],
        ));
  }

  List<Widget> _generateMemberWidget(List<Member>? members) {
    return members!
        .map((entry) => WebBoardButton(
              entry.name,
              onInfo: () {
                _onMemberInfo(context, entry);
              },
              onRemove: () {
                if (widget._onRemove != null) widget._onRemove!(entry.name);
              },
            ))
        .toList();
  }
}
