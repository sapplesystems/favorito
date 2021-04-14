import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  Function onClick;
  EditItem({this.onClick});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => this.onClick(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: myBackGround,
                  border: Border.all(color: myRed),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Icon(
                Icons.edit,
                color: myRed,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Edit Item',
              style: TextStyle(fontSize: 16),
            )
          ],
        ));
  }
}
