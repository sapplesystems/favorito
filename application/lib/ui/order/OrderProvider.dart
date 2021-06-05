import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/Order.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';

class OrderProvider extends BaseProvider {
  OrderProvider() {
    callPageData();
  }

  List<OrderData> allOrdersList = [];
  List<OrderData> newOrdersList = [];
  List<OrderData> inputOrdersList = [];

  String selectedTab = 'New Orders';
  void callPageData() async {
    await WebService.orderList(null, RIKeys.josKeys22.currentContext)
        .then((value) {
      if (value.status == "success") {
        allOrdersList.addAll(value.data);
        for (var va in allOrdersList)
          // if (va.order.isAccepted == 0)
          inputOrdersList.add(va);
      }
      notifyListeners();
    });
  }

  tapNewOrder() {
    selectedTab = 'New Orders';
    inputOrdersList.clear();
    for (var temp in allOrdersList)
      // if (temp.order.isAccepted == 0)
      inputOrdersList.add(temp);
  }

  tapAllOrder() {
    selectedTab = 'All Orders';
    inputOrdersList.clear();
    for (var temp in allOrdersList)
      // if (temp.order.isAccepted != 0)
      inputOrdersList.add(temp);
  }
}
