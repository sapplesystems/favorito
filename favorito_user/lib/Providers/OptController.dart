import 'package:favorito_user/model/appModel/Menu/order/OptionsModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OptController extends ChangeNotifier {
  Map dataMap = Map();

  List<OptionsModel> list = [];

  List<OptionsModel> getOpt() {
    list.clear();
    list.add(OptionsModel(isVeg: true, name: "opt1", val: true, price: "100"));
    return list;
  }

  IconData getOoptionSelecte(val) =>
      val ? Icons.check_box_outline_blank : Icons.check_box;
}
