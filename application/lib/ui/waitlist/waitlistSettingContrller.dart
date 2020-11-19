import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/waitlist/Waitlist.dart';
// import 'package:get/get.dart';

class WaitListController {
  Function function;
  Waitlists wc;
  WaitListController({this.function});

  UpdateWaitList(String str, int id) async {
    await WebService.funWaitlistUpdateStatus({"id": id, "status": str})
        .then((value) {
      print(value.message);
      if (value.status == "success") {
        getPageData();
      }
    });
  }

  Future<WaitlistListModel> getPageData() async {
    await WebService.funGetWaitlist().then((value) {
      return value;
    });
  }
}
