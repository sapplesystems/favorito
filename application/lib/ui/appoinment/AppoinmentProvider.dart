// import 'package:Favorito/model/appoinment/PersonList.dart';
// import 'package:Favorito/model/appoinment/RestrictionOnlyModel.dart';
// import 'package:Favorito/model/appoinment/SettingData.dart';
// import 'package:Favorito/model/campainVerbose.dart';
// import 'package:flutter/material.dart';

// class AppoinmentProvider extends ChangeNotifier{
// List title = [
//     "Waitlist Manager",
//     "Anouncement",
//     "Discription",
//     "Minimum Wait Time",
//     "Slot Length",
//     "Except"
//   ];
// List<String> slot = [
//     "15 min",
//     "30 min",
//     "45 min",
//     "60 min",
//     "75 min",
//     "90 min",
//     "105 min",
//     "130 min"
//   ];


//   Map<String, bool> statusData = {
//     "Services": true,
//     "Person": false,
//     "Both": false
//   };


//   bool servicesDD = false;
//   bool personsDD = false;
  
//   List<String> abc = ["Name", "Mobile", "Email"];
//   List<Data> servicesList;
//   List<String> servicesString = [];
//   List<PersonList> _personList;
//   List<String> _personListTxt = [];
//   SettingData _settingData = SettingData();
//   List<RestrictionOnlyModel> _restrictionList;
//   List<String> _restrictedServicesTxt = [];

//   List<String> list = ["Sunday", "Monday", "TuesDay", "WednesDay"];
//   List<String> selectedList = [];
//   List<TextEditingController> controller = [for (int i = 0; i < 16; i++) TextEditingController()];
//   bool _autoValidateForm = false;

//     AppoinmentProvider(){
//     getRestriction();
//     getService(false);
//     initilizevalues();
//     getSettingdata();
//     getPerson();
//     }
// }
