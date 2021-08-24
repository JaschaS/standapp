import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:standapp/standapp/models/member_model.dart';
import 'package:standapp/standapp/services/http_service.dart';
import 'package:standapp/standapp/widgets/host_screen/web_board_button.dart';
import 'package:standapp/standapp/widgets/host_screen/web_dialog.dart';

import '../../standapp_colors.dart';
import 'member_bar.dart';

class WebMemberWidget extends StatefulWidget {
  final User? user;
  final VoidCallback? updateCurrentHost;

  const WebMemberWidget({
    this.user,
    this.updateCurrentHost,
  }) : super(key: const Key("WebMemberWidget"));

  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<WebMemberWidget> {
  late Future<List<Member>> _members;

  @override
  void initState() {
    super.initState();

    _members = HttpService.getMembers(widget.user!);
  }

  void _onMemberInfo(final Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WebDialog(
          okText: "save",
          existingMember: member,
          callback: (final Member? oldMember, final Member newMember) {
            if (oldMember == null) return;
            if (oldMember != newMember) {
              setState(() {
                _members =
                    HttpService.patchMember(widget.user!, oldMember, newMember);
                if (widget.updateCurrentHost != null) {
                  widget.updateCurrentHost!();
                }
              });
            }
          },
        );
      },
    );
  }

  void _addMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WebDialog(
          callback: (_, member) {
            setState(() {
              _members = HttpService.addMember(widget.user!, member);
            });
          },
          okText: "  add ",
        );
      },
    );
  }

  void _onRemove(final Member member) async {
    setState(() {
      _members = HttpService.deleteMember(widget.user!, member);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
      color: AppColors.blue,
      child: FutureBuilder<List<Member>>(
        future: _members,
        builder: (context, members) {
          if (members.connectionState != ConnectionState.done) {
            return _LoadingMemberWidget();
          }

          if (members.hasData) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _memberWidget(members.data),
              ],
            );
          }

          if (members.hasError) {
            return _showError(members);
          }

          return _LoadingMemberWidget();
        },
      ),
    );
  }

  Widget _memberWidget(final List<Member>? members) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MemberBar(
            addMember: _addMemberDialog,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            width: 797,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _generateMembers(members),
            ),
          ),
        ),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }

  List<Widget> _generateMembers(final List<Member>? members) {
    return members!.where((element) => element.isNotEmpty()).map(
      (entry) {
        return WebBoardButton(
          text: entry.name,
          key: Key("WebBoardButton-${entry.memberId}"),
          onInfo: () {
            _onMemberInfo(entry);
          },
          onRemove: () {
            _onRemove(entry);
          },
        );
      },
    ).toList();
  }

  Widget _showError(final AsyncSnapshot<List<Member>?> snapshot) {
    return Center(
      child: Text("${snapshot.error}"),
    );
  }
}

class _LoadingMemberWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.babyBlue,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _memberBar(),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: 797,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _loadingMembers(),
              ),
            ),
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }

  Widget _memberBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        const SizedBox(
          width: 592,
        ),
        Container(
          width: 55,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _loadingMembers() {
    return List.generate(
      9,
      (index) {
        return Shimmer.fromColors(
          baseColor: AppColors.lightGrey,
          highlightColor: AppColors.weisserAlsWeiss,
          child: Container(
            width: 259,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        );
      },
    );
  }
}
