import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// ignore: must_be_immutable
class SingleSelectionChips extends StatefulWidget {
  List<String> reportList;
  Function selection;
  String selectedChoice;
  SingleSelectionChips({this.reportList, this.selection, this.selectedChoice});
  @override
  _SingleSelectionChipsState createState() => _SingleSelectionChipsState();
}

class _SingleSelectionChipsState extends State<SingleSelectionChips> {
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildChoiceList(),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          backgroundColor: myGrey,
          selectedColor: myRed,
          label: Text(
            item,
            style: TextStyle(color: Colors.white),
          ),
          selected: widget.selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              widget.selectedChoice = item;
            });
            widget.selection(item);
          },
        ),
      ));
    });
    return choices;
  }
}
