import 'package:flutter/material.dart';
import 'package:standapp/standapp/standapp_colors.dart';

import 'board_button.dart';
import 'board_modal.dart';

class BoardsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<BoardsWidget> {
  List<String> _allBoards = [];

  void _addNewBoard(final BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return NewBoardModal(_onCreateBoard);
        });
  }

  void _onCreateBoard(final String value) {
    setState(() {
      this._allBoards.add(value);
    });
  }

  void _onUpdateBoard(final String oldValue, final String newValue) {
    setState(() {
      this._allBoards.remove(oldValue);
      this._allBoards.add(newValue);
    });
  }

  void _onDelete(final String value) {
    setState(() {
      this._allBoards.remove(value);
    });
  }

  void _onInfo(final String value) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return NewBoardModal(
            (newValue) {
              _onUpdateBoard(value, newValue);
            },
            existingText: value,
          );
        });
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
        key: Key("Boards"),
        color: AppColors.blue,
        child: ListView(
          clipBehavior: Clip.hardEdge,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                const SizedBox(width: 15),
                Text(
                  "Boards",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                    onPressed: () => _addNewBoard(context),
                    child: Icon(
                      Icons.create_new_folder_outlined,
                      color: AppColors.darkGray,
                      size: 28,
                    )),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: this._allBoards.length,
              itemBuilder: (context, index) {
                return BoardButton(
                  this._allBoards[index],
                  icon: Icons.folder,
                  onDelete: _onDelete,
                  onInfo: _onInfo,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
            ),
            const SizedBox(height: 25),
          ],
        ));
  }
}
