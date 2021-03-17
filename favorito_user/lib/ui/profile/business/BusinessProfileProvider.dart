import 'package:favorito_user/model/WorkingHoursModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import '../../../utils/RIKeys.dart';

class BusinessProfileProvider extends ChangeNotifier {
  String businessId;
  WorkingHoursModel workingHoursModel = WorkingHoursModel();
  List<String> attribute = [];
  List<String> service = [];
  String _shopTiming = '';
  BusinessProfileProvider() {
    getBusinessHours();
  }
  void getBusinessHours() async {
    print("HourslyId:$businessId");
    await APIManager.workingHours({'business_id': businessId}, RIKeys.josKeys2)
        .then((value) {
      workingHoursModel = value;
      value.data.forEach((e) {
        if (DateFormat('EEEE')
            .format(DateTime.now())
            .toLowerCase()
            .contains(e?.day?.toLowerCase())) {
          var amPm = int.parse(e.startHours.substring(0, 2)) < 12;
          var amPm1 = int.parse(e.endHours.substring(0, 2)) < 12;
          _shopTiming = "${e.startHours.substring(0, 5)}" +
              // (amPm ? 'am' : 'pm') +
              ' - ' +
              e.endHours.substring(0, 5) +
              // (amPm1 ? 'am' : 'pm') +
              '\u{25BC}';
          print("Hoursly33:${_shopTiming}");
        }
      });
      notifyListeners();
    });
  }

  String getShopTime() {
    print("Hoursly4:${_shopTiming}");
    return _shopTiming ?? "ddd";
  }

  setId(String id) {
    businessId = id;
    getBusinessHours();
  }

  getId() => businessId;

  List<WorkingHoursData> getWorkingHoursList() => workingHoursModel.data;
}
