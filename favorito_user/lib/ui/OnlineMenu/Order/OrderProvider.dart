import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/Menu/order/OrderListData.dart';
import 'package:favorito_user/services/APIManager.dart';

class OrderProvicer extends BaseProvider {
  List<OrderListData> _orderListData = [];
  OrderProvicer() {
    userOrderList();
  }
  void userOrderList() async {
    await APIManager.userOrderList().then((value) {
      _orderListData.clear();
      if (value.status == 'success') {
        _orderListData.addAll(value.data);
        notifyListeners();
      }
    });
  }

  List<OrderListData> getUserOrderList() => _orderListData;
}
