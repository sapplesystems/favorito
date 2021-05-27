import 'package:Favorito/component/roundButtonRightIcon.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myColors.dart';

class MyTags extends StatefulWidget {
  List<String> sourceList;
  List<String> selectedList;
  bool directionVeticle = false;
  bool border = true;
  String title;
  String hint;
  Function refresh;
  bool searchable;
  MyTags(
      {this.sourceList,
      this.title,
      this.border,
      this.hint,
      this.selectedList,
      this.directionVeticle,
      this.searchable,
      this.refresh});
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
              validator: (_v) {
                var va;
                // if (widget.selectedList.length > 0) {
                va = null;
                // } else {
                //   va = 'required field';
                // }
                return va;
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              mode: Mode.MENU,
              showSelectedItem: true,
              items: widget.sourceList != null ? widget.sourceList : null,
              label: widget.title,
              hint: widget.hint,
              showSearchBox: widget.searchable ?? true,
              onChanged: (value) {
                setState(() {
                  widget.selectedList.add(value);
                  widget.sourceList.remove(value);
                  widget.refresh();
                });
              })),
      SizedBox(
          height: widget.selectedList.isEmpty
              ? 0
              : widget.directionVeticle
                  ? widget.selectedList != null
                      ? widget.selectedList.length * 50.0
                      : 0
                  : 52,
          child: ListView(
              scrollDirection:
                  widget.directionVeticle ? Axis.vertical : Axis.horizontal,
              children: [
                for (int i = 0; i < (widget.selectedList?.length ?? 0); i++)
                  roundButtonRightIcon(
                      borderColor: widget.border ? myRed : Colors.white,
                      title: widget.selectedList[i],
                      clr: myRed,
                      ico: Icons.close,
                      function: () => setState(() {
                            widget.sourceList.add(widget.selectedList[i]);
                            widget.selectedList.removeAt(i);
                            widget.refresh();
                          }))
              ]))
    ]);
  }
}
