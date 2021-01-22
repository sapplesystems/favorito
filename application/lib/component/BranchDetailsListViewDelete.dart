import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class BranchDetailsListViewDelete extends StatefulWidget {
  List<BranchDetailsModel> inputList;

  BranchDetailsListViewDelete({this.inputList = const []});
  @override
  _BranchDetailsListViewDelete createState() => _BranchDetailsListViewDelete();
}

class _BranchDetailsListViewDelete extends State<BranchDetailsListViewDelete> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      child: Column(children: [
        for (int index = 0; index < widget.inputList.length; index++)
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Center(
              child: Center(
                child: ListTile(
                    leading: Image.network(widget.inputList[index].imageUrl,
                        height: sm.h(8), fit: BoxFit.fill, width: sm.w(8)),
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.inputList.remove(widget.inputList[index]);
                        });
                      },
                    )),
              ),
            ),
          ),
      ]),
    );
  }
}
