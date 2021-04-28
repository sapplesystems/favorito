import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRestriction extends StatelessWidget {
 AppoinmentProvider vaTrue;
  bool _needValidate = false;
  bool isFirst =true;
  MaterialLocalizations localizations;
SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    localizations = MaterialLocalizations.of(context);
    
   vaTrue = Provider.of<AppoinmentProvider>(context,listen: true);
      if(isFirst){
        vaTrue.cleanAll();
        isFirst =false;
      }
        
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
                    vaTrue.controller[0].text = "";
                    Navigator.pop(context);
                  },
          child: Icon(Icons.arrow_back,color: Colors.black,)),
        centerTitle: true,
title: Text('Restrictions',style: titleStyle),
),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
        child: 
        Column(
          children: [
            Card(
                      child: Builder(builder: (context){
                return Form(
                    key: RIKeys.josKeys12,
                    autovalidate: _needValidate,
                  child:    Padding(
                    
                    padding:  EdgeInsets.all(sm.w(4)),
                    child: Column(children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownSearch<String>(

                        validator: (_v) {
                          var va;
                          if (_v == "") {
                va = 'required field';
                          } else {
                va = null;
                          }
                          return va;
                        },
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        mode: Mode.MENU,
                        showSelectedItem: false,
                        maxHeight:170.0,
                        items: ["Services", "Person", "Both"],
                        label: "Select Any",
                        selectedItem: vaTrue.controller[4].text,
                        hint: "Please Select Select Any",
                        showSearchBox: false,
                        onChanged: (_value) {
                          print("_value:$_value");
                        vaTrue.funDropDownChange(_value);
                        }
                      )
                    ),
                    Visibility(
                        visible: vaTrue.getServicesDD(),
                        child: myDropDown(vaTrue.controller[0], "Services", vaTrue.servicesString)),
                    Visibility(
                        visible: vaTrue.getPersonsDD(),
                        child: myDropDown(vaTrue.controller[1], "Person", vaTrue.personListTxt)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {
                         vaTrue.selectDate2(context,localizations);
                        },
                        child: txtfieldboundry(
                isEnabled: false,
                controller: vaTrue.controller[2],
                title: "Start DateTime",
                security: false,
                valid: true),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {
                          vaTrue.selectDate(context,localizations);
                        },
                        child: txtfieldboundry(
                isEnabled: false,
                controller: vaTrue.controller[3],
                title: "End DateTime",
                security: false,
                valid: true)
                      ),
                    )
                    ]),
                  )
                  );
              }),
            ),
         vaTrue.getLoading()?
                CircularProgressIndicator():
                MyOutlineButton(
                  title: "Submit",
                  function: () {
                    if(RIKeys.josKeys12.currentState.validate()){
                      vaTrue.postRestriction(context);
                    }else if(vaTrue.controller[2].text.trim().isEmpty||vaTrue.controller[3].text.trim().isEmpty){
                      BotToast.showText(text: 'Please check start and end date time');
                    }}
                    
                )
          ],
        )
        ),
    );
  }

  Widget myDropDown(
      TextEditingController _controller, String _title, var _dataset) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: DropdownSearch<String>(
          validator: (_v) {
            var va;
            if (_v == "") {
              va = 'required field';
            } else {
              va = null;
            }
            return va;
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          mode: Mode.MENU,
          showSelectedItem: true,
          selectedItem: _controller.text,
          items: _dataset != null ? _dataset : null,
          label: _title,
          hint: "Please Select $_title",
          showSearchBox: true,
          onChanged: (_value) {
            setState(() {
              _controller.text = _value;
            });
          },
        ),
      );
    });
  }

  
}