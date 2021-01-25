import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class BranchDetailsListViewAdd extends StatefulWidget {
  List<BranchDetailsModel> inputList;
  List<BranchDetailsModel> selectedList;

  BranchDetailsListViewAdd(
      {this.inputList = const [], this.selectedList = const []});
  @override
  _BranchDetailsListViewAdd createState() => _BranchDetailsListViewAdd();
}

class _BranchDetailsListViewAdd extends State<BranchDetailsListViewAdd> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Column(
      children: [
        Container(
          height: sm.h(40),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.inputList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Image.network(widget.inputList[index].imageUrl,
                          height: sm.h(8), fit: BoxFit.fill, width: sm.h(8)),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          widget.inputList[index].name,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          widget.inputList[index].address,
                        ),
                      ),
                      trailing: widget.inputList[index].isSelected
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  widget.inputList[index].isSelected = false;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  widget.inputList[index].isSelected = true;
                                });
                              },
                            ),
                    ),
                  ),
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: sm.w(50),
            margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: RoundedButton(
              clicker: () {
                for (var model in widget.inputList) {
                  if (model.isSelected) {
                    widget.selectedList.add(model);
                  }
                }
                widget.inputList.clear();
                Navigator.of(context).pop();
              },
              clr: Colors.red,
              title: "Submit",
            ),
          ),
        ),
      ],
    );
  }
}
