import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPerson extends StatelessWidget {
  AppoinmentProvider vaTrue;
  bool _needValidate = false;
  bool isFirst = true;
SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
   vaTrue = Provider.of<AppoinmentProvider>(context,listen: true);
    if(isFirst){
      vaTrue.cleanAllPerson();
      vaTrue.refresh();
      isFirst = false;
    }
    return   Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
vaTrue.controller[0].text = "";
                Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back,color: Colors.black,)),
        centerTitle: true,
title: Text('Person',style: titleStyle),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: sm.w(4)),
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
                      child: Padding(
                        padding:  EdgeInsets.all(sm.w(3)),
                        child:
                       
                         Builder(builder: (context)=>Form(
                           key: RIKeys.josKeys8,
                          autovalidate:_needValidate,
                          child:  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: 
                              Column(
                           children: [
                myDropDown(vaTrue.controller[3], "Services", vaTrue.servicesString),
                       
                        for (int i = 0; i < 2; i++)     
                            txtfieldboundry(
                                controller: vaTrue.controller[i],
                                title: vaTrue.abc[i],
                                maxlen: i == 1
                                    ? 10
                                    : i == 2
                                        ? 56
                                        : 25,
                                keyboardSet: 
                                i == 1?
                                     TextInputType.number
                                    : i == 2
                                        ? TextInputType.emailAddress
                                        : TextInputType.name
                                ,
                                security: false,
                                myregex: i==1?mobileRegex:(i==2)?emailRegex:null,
                                valid: true),
                          
                       
                    ]),),
                         ))
                      ),
            ),
             vaTrue.getLoading()?Center(child: CircularProgressIndicator()): MyOutlineButton(
                      title: "Submit",
                      function: (){
                        vaTrue.controller[0].text=vaTrue.controller[0].text.trim();
                        if(RIKeys.josKeys8.currentState.validate()){
vaTrue.funAddPerson(context);
                        }else{
                          _needValidate = true;
                          vaTrue.notifyListeners();
                        }
                      }
                    )
          ],
        ),
        
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

