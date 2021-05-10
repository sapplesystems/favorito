import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class Fab extends StatelessWidget {
  Widget build(BuildContext context) {
    var vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(4.0),
          child:
              Icon(Icons.shopping_cart_outlined, size: 32, color: myGreyDark)),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(6)),
          constraints: BoxConstraints(minWidth: 12, minHeight: 12),
          child: Text(vaTrue.getMyObjectsList().length.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center),
        ),
      ),
    ]);
  }
}
