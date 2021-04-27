import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import '../../config/SizeManager.dart';

class ManualAppoinment extends StatelessWidget {
  SizeManager sm;
  AppoinmentProvider vaTrue;
bool isFirst = true;
bool _autovalidate = false;


  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppoinmentProvider>(context,listen: true);
    if(isFirst){
      if(vaTrue.getSelectedAppointmentId()== 0){
        vaTrue.appClean(); 
        vaTrue.controller[0].text = 'Select Date';
        vaTrue.controller[1].text = 'Select Time';
       
      }
      isFirst =false;
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()
          ),
          title:
              Text("Manual Appointment", style: TextStyle(color: Colors.black)),
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                  child: Builder(
                      builder: (context) => Form(
                          key: RIKeys.josKeys13,
                          autovalidate: _autovalidate,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:24.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: sm.w(38),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: InkWell(
                                                          onTap: () {
                                                            vaTrue.showOnlyDatePicker(context,0);
                                                            vaTrue.setDone(true);
                                                          },
                                                          child: SizedBox(
                                                            width: sm.w(40),
                                                            child:
                                                                OutlineGradientButton(
                                                              child: Center(
                                                                  child: Text(
                                                                      vaTrue.controller[
                                                                              0]
                                                                          .text)),
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    Colors.red,
                                                                    Colors.red
                                                                  ]),
                                                              strokeWidth: 1,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          12),
                                                              radius: Radius
                                                                  .circular(8),
                                                            ),
                                                          )))
                                                ]),
                                          ),
                                          SizedBox(
                                              width: sm.w(38),
                                              child: InkWell(
                                                  onTap: () {
                                                    vaTrue.showOnlyTimePicker(context, 1);
                                                  vaTrue.setDone(true);
                                                  },
                                                  child: SizedBox(
                                                    width: sm.h(40),
                                                    child:
                                                        OutlineGradientButton(
                                                      child: Center(
                                                          child: Text(
                                                              vaTrue.controller[1]
                                                                  .text)),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.red,
                                                            Colors.red
                                                          ]),
                                                      strokeWidth: 1,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      radius:
                                                          Radius.circular(8),
                                                    ),
                                                  ))),
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,left:16.0,right:16.0),
                                  child: txtfieldboundry(
                                    controller: vaTrue.controller[2],
                                    title: "Name",
                                    security: false,
                                    valid: true,
                                    myOnChanged: (_){vaTrue.setDone(true);},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:0.0,left:16.0,right:16.0),
                                  child: txtfieldboundry(
                                    controller: vaTrue.controller[3],
                                    title: "Contact",
                                    security: false,
                                    maxlen: 10,
                                    myregex: mobileRegex,
                                    keyboardSet: TextInputType.number,
                                    valid: true,
                                    myOnChanged: (_){vaTrue.setDone(true);},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,left:24.0,right:24.0),
                                  child: DropdownSearch<String>(
                                    key: RIKeys.josKeys14,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      mode: Mode.MENU,
                                      maxHeight:vaTrue.servicesString.length>4? 200:150,
                                      selectedItem: vaTrue.controller[4].text,
                                      items: vaTrue.servicesString,
                                      label: "Service",
                                      hint: "Please Select Service",
                                      showSearchBox: false,
                                      onChanged: (value) {
                                        vaTrue.setDone(true);
                                        vaTrue.controller[4].text = value;
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 24,right: 24, top: 16),
                                  child: DropdownSearch<String>(
                                    key: RIKeys.josKeys15,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      mode: Mode.MENU,
                                      selectedItem: vaTrue.controller[5].text,
                                      items: vaTrue.personListTxt,
                                      maxHeight:(vaTrue.personListTxt?.length??0)>4? 200:((vaTrue.personListTxt?.length??0))*60.0,
                                      label: "Person",
                                      hint: "Please Select Person",
                                      showSearchBox: false,
                                      onChanged: (value) {
                                        vaTrue.setDone(true);
                                        vaTrue.controller[5].text = value;
                                      }
                                          ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16,right: 16,top:8,bottom: 20),
                                  child: txtfieldboundry(
                                    controller: vaTrue.controller[6],
                                    title: "Special Notes",
                                    security: false,
                                    maxLines: 5,
                                    myOnChanged: (_){
                                      vaTrue.setDone(true);
                                    },
                                    valid: true,
                                  ),
                                ),
                              ]))))),
          Visibility(
            visible: vaTrue.getDone(),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(15), vertical: 16.0),
              child: RoundedButton(
                clicker: () {
              if (RIKeys.josKeys13.currentState.validate()) {
                  vaTrue.funSubmitManualAppointment(context);
                }else{
                  _autovalidate = true;
                }},
                clr: Colors.red,
                title: (vaTrue.getSelectedAppointmentId()!=0) ? "Update" : "Save",
              ),
            ),
          ),
        
        ]));
  }

  // void getDataVerbode() async {
  //   await WebService.funAppoinmentVerbose(context).then((value) {
  //     if (value.status == "success") {
  //       var va = value.data;
  //       serviceList = va.serviceList;
  //       for (var va in serviceList) serviceListText.add(va.serviceName);
  //       personList = va.personList;
  //       for (var va in personList) personListText.add(va.personName);
  //       setState(() {});
  //     }
  //   });
  // }
}
