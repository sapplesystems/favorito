import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/appointment/Person.dart';
import 'package:favorito_user/model/appModel/appointment/ServiceModel.dart';
import 'package:favorito_user/ui/appointment/appointmentProvider.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BookAppointment extends StatelessWidget {
  bool isFirst = true;
  // BusinessProfileProvider vaTrue1;
  AppointmentProvider vaTrue;
  bool _needValidate = false;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<AppointmentProvider>(context, listen: true);
    // vaTrue1 = Provider.of<BusinessProfileProvider>(context, listen: true);
    if (isFirst) {
      // vaTrue.baseUserAppointmentVerboseService();
      vaTrue
        ..setMyDetail(context)
        ..serviceReset()
        ..personReset()
        ..slots.clear();
      isFirst = false;
    }
    return SafeArea(
      child: Scaffold(
        key: RIKeys.josKeys30,
        body: Column(children: [
          Row(children: [
            IconButton(
                iconSize: 45,
                color: NeumorphicTheme.isUsingDark(context)
                    ? Colors.white
                    : Colors.black,
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Text(
              "Appointment",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ]),
          Expanded(
            child: Consumer<AppointmentProvider>(
              builder: (context, data, child) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sm.w(8)),
                      child: Center(
                          child: Text(
                              context.read<BusinessProfileProvider>().getBusinessProfileData()?.businessName ??
                                  "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 16,
                                      decoration: TextDecoration.underline))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: sm.w(3), right: sm.w(3), top: sm.h(4)),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 8,
                            lightSource: LightSource.top,
                            color: !NeumorphicTheme.isUsingDark(context)
                                ? Colors.white
                                : null,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(8.0)))),
                        margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                        child: DropdownButton<ServiceModel>(
                          value: data.servicesList[data.selectedServiceSet()]??"",
                          isExpanded: true,
                          hint: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                            child: Text("Select Service",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18)),
                          ),
                          underline: Container(),
                          items: vaTrue.servicesList
                              .map<DropdownMenuItem<ServiceModel>>(
                                  (ServiceModel _va) {
                            return DropdownMenuItem<ServiceModel>(
                                value: _va,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sm.w(2)),
                                    child: Text(
                                      _va.serviceName??"",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: _va.status == 0
                                                  ? myGrey
                                                  : null),
                                    )));
                          })?.toList(),

                          
                          onChanged: (ServiceModel value) {
                            if (value.status == 1)
                              vaTrue.setSelectedService(value, context);
                            else {
                            if(value.serviceName!="Select any")
                              BotToast.showText(
                                  text:
                                      'selected service is not availeble now! Sorry for inconvenience',
                                  duration: Duration(seconds: 3));
                              data.resetServicesId();
                            }
                          }
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.selectedServiceId != 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: sm.h(3), left: sm.w(3), right: sm.w(3)),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              depth: 8,
                              lightSource: LightSource.top,
                              color: !NeumorphicTheme.isUsingDark(context)
                                  ? Colors.white
                                  : null,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(8.0)))),
                          margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                          child: DropdownButton<Person>(
                            isExpanded: true,
                            value: data.personList[data.personList.indexWhere((element) => element.id==data.selectedPersonId)==-1?0:data.personList.indexWhere((element) => element.id==data.selectedPersonId)],
                            hint: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: sm.w(2)),
                              child: Text("Select Service Person",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: myGrey)),
                            ),
                            underline: Container(),
                            items: data.personList
                                ?.map<DropdownMenuItem<Person>>((Person value) {
                              return DropdownMenuItem<Person>(
                                value: value,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: sm.w(2)),
                                  child: Text(value.personName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                ),
                              );
                            })?.toList(),
                            onChanged: (Person value) =>
                              data.setSelectedServicePerson(value)),
                        ),
                      ),
                    ),
                    
                    Visibility(
                      visible: data.selectedServiceId != 0,
                      child: Container(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int _i = 0;
                                _i < data.advancebookingDates.length;
                                _i++)
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: sm.h(1)),
                                child: InkWell(
                                  onTap: () =>data.selectedDateChange(_i, context,
                                        data.advancebookingDates[_i]),
                                  child: Center(
                                      child: Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      lightSource: LightSource.top,
                                      color: !NeumorphicTheme.isUsingDark(context)
                                          ? Colors.white
                                          : null,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.all(
                                              Radius.circular(10.0))),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: sm.w(4)),
                                        child: Text(
                                            dateFormat8.format(
                                                data.advancebookingDates[_i]),
                                            style: TextStyle(
                                                fontSize: sm.h(2),
                                                color:
                                                    '${data.selectedDateIndex}' == '${_i}'
                                                        ? myRed
                                                        :
                                                         Colors.grey[600]))),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  )),
                                ),
                              ),
                          ]),
                      ),
                    ),
                    Visibility(

                      visible: data.selectedServiceId != 0,
                      child: SizedBox(
                        height: 60,
                        child:data.slots.length!=0?
                            ListView(scrollDirection: Axis.horizontal, children: [
                          for (int _i = 0; _i < data.slots.length; _i++)
                            InkWell(
                              onTap: () {
                                data.selectedTimeChange(_i);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 8),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      // depth: 8,
                                      lightSource: LightSource.top,
                                      color: !NeumorphicTheme.isUsingDark(context)
                                          ? Colors.white
                                          : null,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.all(
                                              Radius.circular(8.0)))),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: sm.w(2)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(4)),
                                      child: Text(data.slots[_i].startTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  color:
                                                      data.selectedTimeIndex == _i
                                                          ? myRed
                                                          : Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ]):Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Slots not available",
                          textAlign: TextAlign.center,
                          style:Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: myGrey,fontSize: 18)),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                        child: Divider(height: sm.h(2))),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                        child: Text('Detail',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: myGrey))),
                    Builder(
                        builder: (context) => Form(
                              key: RIKeys.josKeys23,
                              autovalidate: _needValidate,
                              child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: sm.h(4),
                                        left: sm.w(6),
                                        right: sm.w(6)),
                                    child: EditTextComponent(
                                        controller: vaTrue.acces[0].controller,
                                        title: "Name",
                                        valid: true,
                                        hint: "Enter Name",
                                        maxLines: 1,
                                        maxlen: 26,
                                        prefixIcon: 'name',
                                        error: vaTrue.acces[0].error,
                                        security: false)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sm.h(4),
                                      left: sm.w(6),
                                      right: sm.w(6)),
                                  child: EditTextComponent(
                                      controller: vaTrue.acces[1].controller,
                                      title: "Mobile",
                                      hint: "Enter Mobile",
                                      maxLines: 1,
                                      maxlen: 10,
                                      
                                      myregex: emailAndMobileRegex,
                                      prefixIcon: 'phone',
                                      keyboardSet: TextInputType.phone,
                                      error: vaTrue.acces[1].error,
                                      valid: true,
                                      myOnChanged: (val)=>vaTrue.checkMobile(val),
                                        
                                      security: false),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sm.h(4),
                                      left: sm.w(6),
                                      right: sm.w(6)),
                                  child: EditTextComponent(
                                      controller: vaTrue.acces[2].controller,
                                      title: "Special Notes",
                                      maxlen: 200,
                                      hint: "Enter Special Notes",
                                      error: vaTrue.acces[2].error,
                                      maxLines: 8,
                                      security: false),
                                ),
                              ]),
                            )),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: sm.h(4), horizontal: sm.w(12)),
                      child: vaTrue.needSubmit
                          ? Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: myRed,
                                  valueColor: AlwaysStoppedAnimation(myGrey),
                                  strokeWidth: 4),
                            )
                          : NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  // depth: 4,
                                  lightSource: LightSource.topLeft,
                                  color: myBackGround,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.all(Radius.circular(24.0)))),
                              margin:
                                  EdgeInsets.symmetric(horizontal: sm.w(10)),
                              onPressed: () {
                                bool _va=emailAndMobileRegex.hasMatch(vaTrue.acces[1].controller.text);
                                if(_va)vaTrue.funSubmitBooking(context);
                                else BotToast.showText(text: 'Invalid mobile number');
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 16),
                              child: Center(
                                child: Text("Done",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: myRed)),
                              ),
                            ),
                    ),
                    
                    Visibility(
                      visible: data.abletoDelete,
                      child: Container(
                        margin: EdgeInsets.only(top: sm.h(4)),
                        decoration: new BoxDecoration(
                            color: myRedDark1, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(
                              'assets/icon/delete_white.svg',
                              height: sm.h(4)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.abletoDelete,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: sm.h(4), top: sm.h(1)),
                        child: Text('Cancel Booking',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: myRed, fontSize: 16)),
                      ),
                    )
                 
                 
                  ],
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
