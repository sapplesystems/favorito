import 'dart:async';

import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/WorkingHoursModel.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/model/appModel/job/JobListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import '../../../utils/RIKeys.dart';

class BusinessProfileProvider extends BaseProvider {
  String _businessId;
  WaitListDataModel _waitListDataModel = WaitListDataModel();

  WorkingHoursModel workingHoursModel = WorkingHoursModel();
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  List<String> attribute = [];
  List<String> service = [];
  String _shopTiming = '';
  Timer t;
  double per = 0;
  String btnTxt = waitingJoin;
  List<TextEditingController> controller = [];
  JobListModel jobListModel = JobListModel();
  bool waiting = false;

  BusinessProfileProvider() {
    for (int i = 0; i < 3; i++) controller.add(TextEditingController());
    controller[0].text = '1';
  }
  WaitListDataModel getWaitListData() {
    print('abc${_waitListDataModel.businessName}');
    return _waitListDataModel;
  }

  void getBusinessHours() async {
    print("HourslyId:$_businessId");

    await APIManager.workingHours({'business_id': _businessId}, RIKeys.josKeys2)
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

  setBusinessId(String _id) {
    _businessId = _id;
    // abc();
    getProfileDetail();
    getBusinessHours();

    getJobList();
  }

  String getBusinessId() => _businessId;

  List<WorkingHoursData> getWorkingHoursList() => workingHoursModel.data;

  getBusinessProfileData() => _businessProfileData?.data[0];

  Future<void> getProfileDetail() async {
    await APIManager.baseUserProfileDetail(
            {'business_id': _businessId}, RIKeys.josKeys2)
        .then((value) {
      _businessProfileData = value;
      attribute.clear();
      attribute.addAll(value.data[0]?.attributes?.map((e) => e.attributeName));
    });
    getWaitList(false);
  }

  // t.cancel();
  void abc() {
    t = Timer.periodic(new Duration(seconds: 10), (timer) {
      getWaitList(false);
    });
  }

  waitlistVerbose(context) async {
    print("va1:${_businessId}");
    await APIManager.baseUserWaitlistVerbose({'business_id': _businessId})
        .then((value) {
      try {
        if (value.status == 'success') {
          if (value.data.isEmpty) {
            this.snackBar(value.message, RIKeys.josKeys2);
          } else {
            this.snackBar(value.message, RIKeys.josKeys2);
            _waitListDataModel.businessName = value.data[0].businessName;
            _waitListDataModel.partiesBeforeYou =
                value.data[0].partiesBeforeYou;
            _waitListDataModel.availableTimeSlots =
                value.data[0].availableTimeSlots;
            _waitListDataModel.minimumWaitTime = value.data[0].minimumWaitTime;
            notifyListeners();
          }
        }
      } catch (e) {}
    });
  }

  funAdd(bool _val) {
    int i = int.parse(controller[0].text);
    controller[0].text = (_val ? ++i : --i).toString();
    notifyListeners();
  }

  getWaitList(bool val) async {
    await APIManager.baseUserWaitlistGet({'business_id': _businessId})
        .then((value) {
      if (value.status == 'success') {
        if (value.data.length == 0) {
          btnTxt = waitingJoin;
          return;
        }
        try {
          // _waitListDataModel = value?.data[0];
          waiting = true;
          try {
            var difference = DateTime.now()
                .difference((DateTime.parse(_waitListDataModel?.updatedAt)))
                .inMinutes;
            var _min =
                int.parse(_waitListDataModel?.minimumWaitTime?.split(':')[1]);
            if (_min > difference)
              per = ((((_min - difference) * 100) / _min) / 100);
            else
              per = 0.0;
          } catch (e) {
            print('Error:${e.toString()}');
            per = 0.0;
          }
          print("aaaaa${_waitListDataModel?.waitlistStatus}");
          btnTxt = _waitListDataModel?.waitlistStatus == 'rejected'
              ? waitingCanceled
              : (_waitListDataModel?.waitlistStatus == 'pending')
                  ? waitingCancel
                  : (_waitListDataModel?.waitlistStatus == 'accepted')
                      ? 'waiting'
                      : waitingJoin;
        } catch (e) {
          print('Error: $e');
          waiting = false;
        }
      }
      notifyListeners();
    });
  }

  void cancelWaitList() async {
    print("cleared all data");
    await APIManager.baseUserWaitlistCancel(
        {'waitlist_id': _waitListDataModel?.waitlistId}).then((value) {});
  }

  void setWaitList(context) async {
    Map _map = {
      'no_of_person': controller[0].text,
      'name': controller[1].text,
      'special_notes': controller[2].text,
      'business_id': _businessId
    };

    await APIManager.baseUserWaitlistSet(_map).then((value) async {
      if (value.status == 'success') {
        // await data.fun1(true);
        Navigator.pop(context);
      }
    });
  }

  void getJobList() async {
    await APIManager.joblist({'business_id': _businessId}).then((value) {
      jobListModel = value;
      print("joblistlength${value.data.length}");
      notifyListeners();
    });
  }

  allClear() {
    _waitListDataModel = WaitListDataModel();
  }
}
