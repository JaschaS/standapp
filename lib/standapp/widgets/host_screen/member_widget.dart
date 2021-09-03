import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:standapp/standapp/models/member_model.dart';
import 'package:standapp/standapp/clients/backend_client.dart';
import 'package:standapp/standapp/widgets/host_screen/board_button.dart';
import 'package:standapp/standapp/widgets/host_screen/member_dialog.dart';

import '../../standapp_colors.dart';
import 'member_bar.dart';

class MemberWidget extends StatefulWidget {
  final User? user;
  final VoidCallback? updateCurrentHost;

  const MemberWidget({
    this.user,
    this.updateCurrentHost,
  }) : super(key: const Key("WebMemberWidget"));

  @override
  State<StatefulWidget> createState() => _MemberState();
}

class _MemberState extends State<MemberWidget> {
  late Future<List<Member>> _members;

  @override
  void initState() {
    super.initState();

    _members = BackendClient.getMembers(widget.user!);
  }

  void _onMemberInfo(final Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemberDialog(
          okText: "save",
          existingMember: member,
          callback: (final Member? oldMember, final Member newMember) {
            if (oldMember == null) return;
            if (oldMember != newMember) {
              setState(() {
                _members = BackendClient.patchMember(
                    widget.user!, oldMember, newMember);
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
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 615) {
      showDialog(
        context: context,
        builder: (context) {
          return MemberDialog(
            callback: (_, member) {
              setState(() {
                _members = BackendClient.addMember(widget.user!, member);
              });
            },
            okText: "  add ",
          );
        },
      );
    } else {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return MemberBottomSheet(
            callback: (_, member) {
              setState(() {
                _members = BackendClient.addMember(widget.user!, member);
              });
            },
            okText: "add",
          );
        },
      );
    }
  }

  void _onRemove(final Member member) async {
    setState(() {
      _members = BackendClient.deleteMember(widget.user!, member);
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
            return _memberWidget(members.data);
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
    return LayoutBuilder(builder: (context, constraints) {
      double barWidth = 65;
      double buttonWidth = 265;
      int buttonsInRow = 1;
      if (constraints.maxWidth > 830) {
        barWidth = 620;
        buttonWidth = 267;
        buttonsInRow = 3;
      } else if (constraints.maxWidth > 575) {
        barWidth = 365;
        buttonWidth = 280;
        buttonsInRow = 2;
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MemberBar(
              width: barWidth,
              addMember: _addMemberDialog,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            // button-width * how many buttons a row should have + spacing * (how many spacing exists)
            width: buttonWidth * buttonsInRow + 10 * (buttonsInRow - 1),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _generateMembers(members, buttonWidth),
            ),
          ),
          const SizedBox(
            height: 150,
          )
        ],
      );
    });
  }

  List<Widget> _generateMembers(
    final List<Member>? members,
    final double width,
  ) {
    return members!.where((element) => element.isNotEmpty()).map(
      (entry) {
        return BoardButton(
          text: entry.name,
          buttonWidth: width,
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
    return LayoutBuilder(builder: (context, constraints) {
      double barWidth = 65;
      double buttonWidth = 265;
      int buttonsInRow = 1;
      if (constraints.maxWidth > 830) {
        barWidth = 620;
        buttonWidth = 267;
        buttonsInRow = 3;
      } else if (constraints.maxWidth > 575) {
        barWidth = 363;
        buttonWidth = 280;
        buttonsInRow = 2;
      }

      return Container(
        color: AppColors.babyBlue,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _memberBar(barWidth),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: buttonWidth * buttonsInRow + 10 * (buttonsInRow - 1),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _loadingMembers(buttonWidth),
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            )
          ],
        ),
      );
    });
  }

  Widget _memberBar(final double width) {
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
        SizedBox(
          width: width,
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

  List<Widget> _loadingMembers(final double width) {
    return List.generate(
      9,
      (index) {
        return Shimmer.fromColors(
          baseColor: AppColors.lightGrey,
          highlightColor: AppColors.weisserAlsWeiss,
          child: Container(
            width: width,
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
