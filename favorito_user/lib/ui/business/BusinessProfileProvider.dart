import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/WorkingHoursModel.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/model/appModel/job/JobListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class BusinessProfileProvider extends BaseProvider {
  WaitListDataModel _waitListDataModel = WaitListDataModel();
  bool _isProgress = true;
  WorkingHoursModel workingHoursModel = WorkingHoursModel();
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  List<String> attribute = [];
  List<String> service = [];
  String _shopTiming = '';
  bool timerTime = false;
  double per = 0.3;
  String btnTxt = waitingJoin;
  List<TextEditingController> controller = [];
  JobListModel jobListModel = JobListModel();
  bool isWaiting = false;
  ScrollController scrollController = ScrollController();
  int remainTime;
  bool _getWaitlistDone = false;

  bool getIsProgress() => _isProgress;

  setIsProgress(bool _val) {
    _isProgress = true;
  }

  bool getWaitlistDone() => _getWaitlistDone;

  setWaitlistDone(bool _val) {
    _getWaitlistDone = _val;
  }

  BusinessProfileProvider() : super() {
    for (int i = 0; i < 3; i++) controller.add(TextEditingController());
    controller[0].text = '1';
  }

  WaitListDataModel getWaitListData() {
    return _waitListDataModel;
  }

  void getBusinessHours() async {
    print("HourslyId:${this.getBusinessId()}");

    await APIManager.workingHours(
            {'business_id': this.getBusinessId()}, RIKeys.josKeys2)
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

  refresh(int _i) {
    switch (_i) {
      case 1:
        {
          print("tullu:1");
          getProfileDetail();
          getBusinessHours();
          getJobList();
          break;
        }

      case 2:
        {
          print("tullu:2");
          getBusinessHours();
          break;
        }

      case 3:
        {
          print("tullu:3");
          getBusinessHours();
          break;
        }
      case 4:
        // callhere appointment verbose
        break;
    }
  }

  List<WorkingHoursData> getWorkingHoursList() => workingHoursModel.data;

  getBusinessProfileData() => _businessProfileData?.data[0];

  Future<void> getProfileDetail() async {
    await APIManager.baseUserProfileDetail(
            {'business_id': this.getBusinessId()}, RIKeys.josKeys2)
        .then((value) {
      try {
        _isProgress = false;
        _businessProfileData = value;
        attribute.clear();
        attribute
            .addAll(value.data[0]?.attributes?.map((e) => e.attributeName));
      } catch (e) {
        BotToast.showText(text: e.toString());
      } finally {
        notifyListeners();
      }
    });
  }

  waitlistVerbose(context) async {
    _isProgress = true;
    print("va1:${this.getBusinessId()}");
    await APIManager.baseUserWaitlistVerbose(
            {'business_id': this.getBusinessId()}, RIKeys.josKeys2)
        .then((value) {
      _isProgress = false;
      try {
        if (value.status == 'success') {
          if (value.data.isEmpty) {
            print('rohit');
            this.snackBar(value.message, RIKeys.josKeys2);
            Navigator.pop(context);
          } else {
            _waitListDataModel.businessName = value.data[0].businessName;
            _waitListDataModel.partiesBeforeYou =
                value.data[0].partiesBeforeYou;
            _waitListDataModel.availableTimeSlots =
                value.data[0].availableTimeSlots;
            _waitListDataModel.minimumWaitTime = value.data[0].minimumWaitTime;
            _waitListDataModel.slotLength = value.data[0].slotLength;
            notifyListeners();
          }
        } else
          Navigator.pop(context);
      } catch (e) {} finally {
        getWaitList();
      }
    });
  }

  funAdd(bool _val) {
    int i = int.parse(controller[0].text);
    controller[0].text = (_val
            ? ++i
            : int.parse(controller[0].text) > 1
                ? --i
                : controller[0].text)
        .toString();
    notifyListeners();
  }

  void getWaitList() async {
    _isProgress = true;
    await APIManager.baseUserWaitlistGet({'business_id': this.getBusinessId()})
        .then((value) {
      setWaitlistDone(true);
      _isProgress = false;
      if (value.status == 'success') {
        if (value.data == null) {
          isWaiting = false;
          btnTxt = waitingJoin;
          notifyListeners();
          return;
        }
        if (value.data.length > 0) {
          isWaiting = true;
          _waitListDataModel.noOfPerson = value.data[0].noOfPerson;
          _waitListDataModel.availableTimeSlots = value.data[0].bookedSlot;
          _waitListDataModel.waitlistId = value.data[0].waitlistId;
          _waitListDataModel.partiesBeforeYou = value.data[0].partiesBeforeYou;
          _waitListDataModel.updatedAt = value.data[0].updatedAt;
          _waitListDataModel.waitlistStatus = value.data[0].waitlistStatus;
          try {
            DateTime now = DateTime.now();
            DateTime updated = DateTime.parse(_waitListDataModel?.updatedAt);

            String slot = _waitListDataModel?.availableTimeSlots;
            List d = updated.toString().split(' ');
            DateTime properSlot = DateTime.parse("${d[0]} $slot:00");
            DateTime startTime = properSlot == updated
                ? properSlot
                : properSlot.difference(updated).isNegative
                    ? updated
                    : properSlot;
            print("sss4 : $startTime");
            if (now.isAfter(startTime.add(Duration(
                minutes: int.parse(_waitListDataModel.minimumWaitTime))))) {
              per = 0.0;
              remainTime = 0;
            } else {
              timerTime = now.isAfter(startTime);
              print("sss4 : $timerTime");
              int waitTime = int.parse(_waitListDataModel.minimumWaitTime);

              int s = now.difference(startTime).inMinutes;

              if (timerTime) {
                print("sss3 : $timerTime"); //to remaining wait time
                print("ssss1$s");
                print("ssss2$waitTime");
                var temp = s / waitTime;
                per = 1 - temp;
                remainTime = waitTime - s - 1;
              }
              print("ssss3$per");
            }
          } catch (e) {
            per = 0.1;
            print("Errors:${e.toString()}");
          } finally {
            notifyListeners();
          }
          btnTxt = value?.data[0].waitlistStatus == 'rejected'
              ? waitingCanceled
              : (value?.data[0]?.waitlistStatus == 'pending')
                  ? waitingCancel
                  : (value?.data[0]?.waitlistStatus == 'accepted')
                      ? 'waiting'
                      : waitingJoin;
        }
      }
    });
    // recall();
  }

  void cancelWaitList() async {
    print("cleared all data");
    await APIManager.baseUserWaitlistCancel(
            {'waitlist_id': _waitListDataModel?.waitlistId}, RIKeys.josKeys2)
        .then((value) {
      isWaiting = false;
      if (value.status == 'success') {
        btnTxt = waitingJoin;
        Navigator.pop(RIKeys.josKeys2.currentContext);
      }
    });
  }

  void setWaitList(context) async {
    Map _map = {
      'no_of_person': controller[0].text,
      'name': controller[1].text,
      'special_notes': controller[2].text,
      'business_id': this.getBusinessId(),
      'slot': _waitListDataModel.availableTimeSlots
    };

    await APIManager.baseUserWaitlistSet(_map).then((value) async {
      if (value.status == 'success') {
        // getWaitList();
        Navigator.pop(context);
      }
    });
  }

  void getJobList() async {
    await APIManager.joblist({'business_id': this.getBusinessId()})
        .then((value) {
      jobListModel = value;
      print("joblistlength${value.data.length}");
      notifyListeners();
    });
  }

  void allClear() {
    _waitListDataModel = WaitListDataModel();
  }

  abc() {
    notifyListeners();
  }

  joinWaitlistClear() {
    try {
      controller[0].text = '1';
      controller[1].text = '';
      controller[2].text = '';
    } catch (e) {}
  }

  catalogList() async {
    await APIManager.baseUserProfileBusinessCatalogList(
        {"business_id": this.getBusinessId()}).then((value) {});
  }
}

// per = (((100 * (waitTime - now.difference(startTime).inMinutes)) /
//     waitTime));
// per = double.parse(
//     ((((100 * (waitTime - now.difference(startTime).inMinutes)) /
//                     waitTime) /
//                 (waitTime - now.difference(startTime).inMinutes)) /
//             10)
//         .toStringAsFixed(1));
