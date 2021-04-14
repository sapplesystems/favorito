import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class DeleteItem extends StatelessWidget {
  Function onClick;
  DeleteItem({this.onClick});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => this.onClick(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  border: Border.all(color: myRed),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Icon(
                Icons.delete,
                color: myRed,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Delete Item',
              style: TextStyle(fontSize: 16),
            )
          ],
        ));
  }
}
