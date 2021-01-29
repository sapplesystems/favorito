import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class Fab extends StatelessWidget {
  Widget build(BuildContext context) {
    var vaFalse = Provider.of<BasketControllers>(context, listen: false);
    var vaTrue = Provider.of<BasketControllers>(context, listen: true);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: new Icon(
            Icons.shopping_cart_outlined,
            size: 32,
          ),
        ),
        new Positioned(
          right: 0,
          top: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              vaTrue.getMyObjectsList().length.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
