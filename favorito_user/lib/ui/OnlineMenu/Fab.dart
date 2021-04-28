import 'package:favorito_user/Providers/BasketControllers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class Fab extends StatelessWidget {
  Widget build(BuildContext context) {
    var vaTrue = Provider.of<BasketControllers>(context, listen: true);
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.shopping_cart_outlined, size: 32)),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(6)),
          constraints: BoxConstraints(minWidth: 12, minHeight: 12),
          child: Text(vaTrue.getMyObjectsList().length.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center),
        ),
      ),
    ]);
  }
}
