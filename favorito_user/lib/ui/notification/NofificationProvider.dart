import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/OffersModel.dart';
import 'package:favorito_user/services/APIManager.dart';

class NotificationProvider extends BaseProvider {
  List<Data> offersListData = [];
  NotificationProvider() {
    userOfferList();
  }

  void userOfferList() async {
    await APIManager.getOffers().then((value) {
      offersListData.clear();
      if (value.status == 'success') {
        offersListData.addAll(value.data);
        print(offersListData.length);
        notifyListeners();
      }
    });
  }

  void updateOfferstatus(index) async {
    await APIManager.updateOffers(
        {"offerid": offersListData[index].id, "offer_Status": 1}).then((value) {
      if (value.status == 'success') {
        offersListData[index].offerStatus = "1";
        notifyListeners();
      }
    });
  }
}
