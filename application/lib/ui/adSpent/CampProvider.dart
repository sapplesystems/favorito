import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/network/webservices.dart';
import '../../model/adSpentModel.dart';
class CampProvider extends BaseProvider{
    int totalSpent = 0;
  int freeCredit = 0;
  int paidCredit = 0;
  List<Data> list = [];
  Data data = Data();

  CampProvider(){}


  void initCall() {
    getPageData();
  }

  void getPageData() {
    WebService.getAdSpentPageData().then((value) {
      if (value.status == "success") {
        
          totalSpent = value.totalSpent;
          freeCredit = value.freeCredit;
          paidCredit = value.paidCredit;
          list.clear();
          list.addAll(value.data);
        notifyListeners();
      }
    });
  }
}
