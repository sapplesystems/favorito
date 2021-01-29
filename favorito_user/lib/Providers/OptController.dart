import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OptController extends ChangeNotifier {
  Map dataMap = Map();

  List<Options> list = [];

  List<Options> getOpt() {
    list.add(Options(isVeg: true, name: "opt1", val: true, price: "100"));
    return list;
  }

  IconData getOoptionSelecte(ico) => (ico == Icons.check_box)
      ? Icons.check_box_outline_blank
      : Icons.check_box;
}

class Options {
  bool isVeg;
  bool val;
  String name;
  String price;

  Options({this.isVeg, this.val, this.name, this.price});
}
