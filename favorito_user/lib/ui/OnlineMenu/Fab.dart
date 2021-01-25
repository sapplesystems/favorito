import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Fab extends StatefulWidget {
  Basket basket = Basket();
  @override
  FabState createState() => basket.getFabState();
}

class FabState extends State<Fab> {
  Basket basket = Basket();
  int counter = 0;
  refresh() {
    setState(() {
      counter = basket.getMyObjectsList().length;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              counter.toString(),
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
