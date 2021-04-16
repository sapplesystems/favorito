
import 'package:Favorito/model/appoinment/PersonList.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/model/appoinment/appointmentServiceOnlyModel.dart';

class AppoinmentProvider extends ChangeNotifier{
List<String> abc = ["Name", "Mobile", "Email"];
List<TextEditingController> controller =[for(int _i=0;_i<8;_i++)TextEditingController()];

  List<String> personListTxt = [];
  List<PersonList> _personList;
  List<String> servicesString = [];
  List<Data> servicesList;

    funAddPerson(context)async{
      
       int _serviceId;
                for (var _va in servicesList) {
                  if (_va.serviceName == controller[3].text) {
                    _serviceId = _va.id;
                  }
                }
      
                Map _map = {
                  "person_name": controller[0].text,
                  "service_id": _serviceId,
                  "person_mobile": controller[1].text,
                  "person_email": controller[2].text
                };
                print("_map:${_map}");
                if (controller[7].text != null && controller[1].text != "") {
                 
                await WebService.funAppoinmentSavePerson(_map, context).then((value) {
                  
                    if (value.status == "success") {
                      // getPerson();
                      BotToast.showText(
                          text: value.message, duration: Duration(seconds: 5));
                      Navigator.pop(context);
                      for (int i = 0; i < 5; i++) controller[i].text = "";
                    }
                  });
                }
    }

void getPersonCall(context) async {
    await WebService.funAppoinmentPerson(context).then((_value) {
      if (_value.status == "success") {
        setPerson(_value.data);
        personListTxt.clear();
        for (var _va in _personList) personListTxt.add(_va.personName ?? "");
      controller[12].text = "";
      notifyListeners();
      }
    });
  }
getPerson()=>_personList;
setPerson(List _val){
  _personList = _val;
  notifyListeners();
}
}