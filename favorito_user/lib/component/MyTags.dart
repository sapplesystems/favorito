import 'package:dropdown_search/dropdown_search.dart';
import 'package:favorito_user/component/RoundButtonRightIcon.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';

class MyTags extends StatefulWidget {
  List<String> sourceList;
  List<String> selectedList;
  bool directionVeticle = false;
  bool border = true;
  String title;
  String hint;
  MyTags(
      {this.sourceList,
      this.title,
      this.border,
      this.hint,
      this.selectedList,
      this.directionVeticle});
  @override
  _MyTagsState createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: DropdownSearch<String>(
              validator: (v) => v == '' ? "required field" : null,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              mode: Mode.MENU,
              showSelectedItem: true,
              items: widget.sourceList != null ? widget.sourceList : null,
              label: widget.title,
              hint: widget.hint,
              showSearchBox: true,
              onChanged: (value) {
                setState(() {
                  widget.selectedList.add(value);
                  widget.sourceList.remove(value);
                });
              })),
      SizedBox(
          height: widget.selectedList.isEmpty
              ? 0
              : widget.directionVeticle
                  ? widget.selectedList != null
                      ? widget.selectedList.length * 56.0
                      : 0
                  : 52,
          child: ListView(
              scrollDirection:
                  widget.directionVeticle ? Axis.vertical : Axis.horizontal,
              children: [
                for (int i = 0; i < widget.selectedList.length; i++)
                  RoundButtonRightIcon(
                      borderColor: widget.border ? myRed : Colors.white,
                      title: widget.selectedList[i],
                      clr: myRed,
                      icon: Icons.close,
                      function: () => setState(() {
                            widget.sourceList.add(widget.selectedList[i]);
                            widget.selectedList.removeAt(i);
                          }))
              ]))
    ]);
  }
}
