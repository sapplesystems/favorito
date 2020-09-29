import 'package:Favorito/component/roundButtonRightIcon.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myColors.dart';
class MyTags extends StatefulWidget {
  List<String> sourceList;
  List<String> selectedList;
  TextEditingController controller;

  String title;
  String hint;
  MyTags(
      {this.controller,
      this.sourceList,
      this.title,
      this.hint,
      this.selectedList});
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
              autoValidate: true,
              mode: Mode.MENU,
              showSelectedItem: true,
              selectedItem: widget.controller.text,
              items: widget.sourceList != null ? widget.sourceList : null,
              label: widget.title,
              hint: widget.hint,
              showSearchBox: true,
              onChanged: (value) {
                setState(() {
                  widget.controller.text = value;
                  widget.selectedList.add(value);
                  widget.sourceList.remove(value);
                });
              })),
      SizedBox(
          height: widget.selectedList.isEmpty ? 0 : 52,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < widget.selectedList.length; i++)
              roundButtonRightIcon(
                  title: widget.selectedList[i],
                  clr: myRed,
                  ico: Icons.close,
                  function: () => setState(() {
                        widget.sourceList.add(widget.selectedList[i]);
                        widget.selectedList.removeAt(i);
                      }))
          ]))
    ]);
  }
}
