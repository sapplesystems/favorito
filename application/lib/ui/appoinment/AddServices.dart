import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServices extends StatelessWidget {
   AppoinmentProvider vaTrue;
   SizeManager sm;
   bool _validate=false;
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<AppoinmentProvider>(context,listen: true);
    sm = SizeManager(context);
    return Scaffold(
      key: RIKeys.josKeys9,
      backgroundColor: myBackGround,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
                Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back,color: Colors.black)),
        centerTitle: true,
title: Text('Services',style: titleStyle),

      ),
      body:ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: sm.w(6)),
          child: txtfieldboundry(
              controller: vaTrue.controller[6],
              title: "Service name",
              error: _validate?(vaTrue.controller[6].text.trim().length>0)?null:'Field required':null,
              security: false,
              valid: true),
        ),
       vaTrue.getLoading()?Center(child: CircularProgressIndicator()): MyOutlineButton(
          title: "Submit",
          function: () {

            if(vaTrue.controller[6].text.trim().length>0){
            vaTrue.funAddServicesCall();
            }else {
              _validate = true;
              vaTrue.notifyListeners();
            }
            
          },
        )
      ])
  

      
    );
  }
}