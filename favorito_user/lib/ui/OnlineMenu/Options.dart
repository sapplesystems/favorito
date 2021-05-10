import 'package:favorito_user/component/VegNonVegMarka.dart';
import 'package:favorito_user/model/appModel/Menu/order/OptionsModel.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class Options extends StatelessWidget {
  OptionsModel _opt = OptionsModel();

  var providerBasketTrue;
  bool val = false;
  @override
  Widget build(BuildContext context) {
    _opt.isVeg = true;
    _opt.name = "Olive Carry";
    _opt.price = "100";
    _opt.val = val;
    providerBasketTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    return InkWell(
      onTap: () {
        val = !val;
        _opt.val = val;
        providerBasketTrue.addOptionsToList(_opt, val);
        // providerBasketTrue.notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          VegNonVegMarka(isVeg: true),
          Icon(
            val ? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.grey,
          ),
          Text(_opt.name),
          Text(_opt.price + "\u{20B9}")
        ]),
      ),
    );
  }
}
