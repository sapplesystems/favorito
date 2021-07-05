import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/appModel/appointment/AppSerModel.dart';
import 'package:favorito_user/model/appModel/appointment/Person.dart';
import 'package:favorito_user/model/appModel/appointment/ServiceModel.dart';
import 'package:favorito_user/model/appModel/appointment/SettingModel.dart';
import 'package:favorito_user/model/appModel/appointment/Slots.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/utils/Acces.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AppointmentProvider extends ChangeNotifier {
  AppSerModel _appSerModel = AppSerModel();
  //all Services list
  List<ServiceModel> servicesList = [
    ServiceModel(id: 0, serviceName: 'Select any', status: 0)
  ];
  // List<String> _servicesNameList = [];
  ServiceModel _selectedService = ServiceModel();
  int selectedServiceId = 0;
  List<SettingModel> settingList = [];
  Person selectedPerson = Person();
  List<Person> personList = [Person(id: 0, personName: 'No data')];
// List<String> _personNameList =[];
  List<DateTime> advancebookingDates = [];
  int selectedPersonId = 0;
  Person selectesPersonName;
  int selectedDateIndex ;
  int selectedTimeIndex = 0;
  bool abletoDelete = false;
  List<Slots> slots = [];
  bool needSubmit = false;
  AppSerModel getAppSerModel() => _appSerModel;
  List<Acces> acces = [for (int i = 0; i < 5; i++) Acces()];
  List<ServiceModel> getServicesList() => servicesList;


  setSelectedService(ServiceModel _val, BuildContext context) {
    _selectedService = _val;
    for (int _i = 0; _i < servicesList.length; _i++) {
      if (_selectedService.id == servicesList[_i].id) {
        selectedServiceId = servicesList[_i].id;
        selectedPersonId = 0;
        baseUserAppointmentPersonByServiceid(context);
      }
    }
    notifyListeners();
  }

  void baseUserAppointmentVerboseService(context) async {
    var _date = dateFormat1.format(advancebookingDates.isNotEmpty?advancebookingDates[selectedDateIndex]:DateTime.now());
    Map _map = {'business_id': getBusinessId(context),'date':_date};
    print("_map:${_map.toString()}");
    await APIManager.baseUserAppointmentVerboseService(
        _map).then((value) {
      if (value.status == 'success') {
         _appSerModel = value;
    servicesList.replaceRange(1, servicesList.length, value.data[0].service);
    settingList.replaceRange(0, settingList.length, value.data[0].setting);
    advancebookingDates.clear();
    advancebookingDates
        .addAll(getDaysInBeteween(settingList[0].advanceBookingEndDays));
    notifyListeners();
      }
    });
  }

  void baseUserAppointmentPersonByServiceid(context) async {
    Map _map = {
      'business_id': getBusinessId(context),
      'service_id': selectedServiceId,
      // 'date': dateFormat1.format(advancebookingDates[selectedDateIndex]),
    };
    print("_map1:${_map}");
    // _personNameList.clear();
    personList.clear();
    personList.add(Person(id: 0, personName: 'No data'));
    await APIManager.baseUserAppointmentPersonByServiceid(_map).then((value) {
      if (value.status == 'success') {
        if (value.data.isNotEmpty) {
          personList.clear();
          personList.addAll(value.data);
          selectedPersonId = personList.first.id;
        }
        // print("dddddd:${value?.data?.length}");
        // for(int _i=0;_i<value?.data?.length;_i++){
        // if(!_personNameList.contains(value.data[_i].personName)){
        //   _personNameList.add(value.data[_i].personName);
        // }
        // }
        notifyListeners();
      }
    });
  }

//personlist gettter setter
// List<String> getPersonNameList()=>_personNameList;
  List<Person> getPersonList() => personList;

  setSelectedServicePerson(Person _val) {
    selectedPerson = _val;
    for (int _i = 0; _i < personList.length; _i++) {
      if (_val.personName == personList[_i].personName) {
        selectedPersonId = personList[_i].id;
        selectesPersonName = personList[_i];
      } else {
        selectesPersonName = Person();
      }
    }

    print(selectedPerson.personName);
    notifyListeners();
  }

  int selectedPersonSet() {
    int _v = 0;
    if (selectedPersonId != 0)
      _v = personList.indexWhere((element) => element.id == selectedPersonId);
    return _v;
  }

  int selectedServiceSet() {
    int _v = 0;
    if (selectedServiceId != 0)
      _v =
          servicesList.indexWhere((element) => element.id == selectedServiceId);
    return _v;
  }

  resetServicesId() {
    selectedServiceId = 0;
    selectedPersonId = 0;
    personList.clear();
    personList.add(Person(id: 0, personName: 'No data'));

    notifyListeners();
  }

  getBusinessId(context) =>
      Provider.of<BusinessProfileProvider>(context, listen: false)
          .getBusinessId();

  List<DateTime> getDaysInBeteween(int _days) {
    print("asw:${_days}");
    List<DateTime> days = [];
    for (int i = 0;
        i <=
            (DateTime.now().add(Duration(days: _days)))
                .difference(DateTime.now())
                .inDays;
        i++) {
      days.add(DateTime.now().add(Duration(days: i)));
    }
    return days;
  }

  selectedDateChange(int _v, context, _date) async {
    selectedDateIndex = _v;
    String _id = getBusinessId(context);
    String _dates = dateFormat1.format(_date);
    Map _map = {'business_id': _id, 'date': _dates,'person_id':selectedPersonId,'services_id':selectedServiceId};
    print("_map:${_map.toString()}");
    slots.clear();
    await APIManager.baseUserAppointmentSlots(_map).then((value) {
      print(value.data.slots.length);
      slots.addAll(value.data.slots);
    });
    // baseUserAppointmentVerboseService(context);
    // baseUserAppointmentPersonByServiceid(context);
    notifyListeners();
  }

  selectedTimeChange(int _i) {
    selectedTimeIndex = _i;
    notifyListeners();
  }

  void setMyDetail(context) {
    acces[0].controller.text =
        Provider.of<PersonalInfoProvider>(context, listen: false)
                ?.profileModel
                ?.data
                ?.detail
                ?.fullName ??
            '';
    acces[1].controller.text =
        Provider.of<PersonalInfoProvider>(context, listen: false)
                ?.profileModel
                ?.data
                ?.detail
                ?.phone ??
            '';
    notifyListeners();
  }

  funSubmitBooking(context) async {
    String _buid = getBusinessId(context);

    if (selectedServiceId == 0) {
      BotToast.showText(text: 'Service not selected');
      return;
    }
    if (selectedPersonId == 0) {
      BotToast.showText(text: 'Person not selected');
      return;
    }
    if (acces[0].controller.text.isEmpty) {
      acces[0].error = 'Please Enter name';
      notifyListeners();
      return;
    } else {
      acces[0].error = null;
      notifyListeners();
    }

    if (acces[1].controller.text.isEmpty) {
      acces[1].error = 'Please Enter contact number';
      notifyListeners();
      return;
    } else {
      acces[1].error = null;
      notifyListeners();
    }
    if (slots.length == 0) {
      BotToast.showText(text: 'Slot not selected');
      return;
    }
    // slots[selectedTimeIndex].startTime
    print('dddd${slots.length}');

    Map _map = {
      'service_id': selectedServiceId,
      'person_id': selectedPersonId,
      'date_time':
          '${dateFormat1.format(advancebookingDates[selectedDateIndex])} ${slots[selectedTimeIndex].startTime}',
      'name': acces[0].controller.text,
      'phone': acces[1].controller.text,
      'special_notes': acces[2].controller.text,
      'business_id': _buid
    };
    print("_map:${_map}");
    await APIManager.baseUserAppointmentCreate(_map).then((value) {
      if (value.status == 'success') {
        Navigator.pop(context);
      }
    });
  }

  serviceReset() {
    selectedServiceId = 0;
  }

  personReset() {
    selectedPersonId = 0;
  }

checkMobile(val){
    if(val.toString().trim().length!=10){
      acces[1].error="Invalid mobile no";
      notifyListeners();
      }else
      acces[1].error=null;
    
    notifyListeners();  
}

}
