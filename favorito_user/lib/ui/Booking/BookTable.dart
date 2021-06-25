import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class BookTable extends StatelessWidget {
  SizeManager sm;

  var fut;
  bool isFirst = true;


  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    
    return Scaffold(
        // backgroundColor: myBackGround,
        body:
        
        
  Consumer<AppBookProvider>(builder: (context,data,child){
    if (isFirst) {
      fut = data
        ..setIsVerboseCall(true)
        ..bookingVerbose(context)
        ..setMyDetail(context);
      isFirst = false;
    }
    return  data.getIsVerboseCall()
            ? Center(
                child: CircularProgressIndicator(
                    backgroundColor: myRed,
                    valueColor: AlwaysStoppedAnimation(myGrey),
                    strokeWidth: 4),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  // vaTrue.baseUserBookingVerbose();
                },
                child: SafeArea(
                  child: Scaffold(
                    
                    appBar: AppBar(
                      backgroundColor: NeumorphicTheme.isUsingDark(context)
                          ? Colors.grey[850]
                          : Color(0xffF4F6FC),
                      elevation: 0,
                      leading: IconButton(
                          color: Colors.black,
                          iconSize: 45,
                          icon: Icon(Icons.keyboard_arrow_left),
                          onPressed: () => Navigator.of(context).pop()),
                      title: Text("Book Table",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ),
                    key: RIKeys.josKeys19,
                    body: ListView(shrinkWrap: true, children: [
                      Text(
                          data
                                  .getBookTableVerbose()
                                  ?.data
                                  ?.businessName
                                  ?.capitalize() ??
                              "",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 18)),
                      Padding(
                          padding: EdgeInsets.only(top: sm.h(2), left: sm.w(6)),
                          child: Row(children: [
                            Text('How many guests?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: myGrey, fontSize: 12))
                          ])),
                      Padding(
                        padding: EdgeInsets.only(
                            top: sm.h(3), left: sm.w(6), right: sm.w(6)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                  'assets/icon/man_book_table.svg'),
                              Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: sm.w(4)),
                                width: sm.w(22),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    depth: -10,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(24)),
                                    color: NeumorphicTheme.isUsingDark(context)
                                        ? Colors.grey[850]
                                        : Color(0xffF4F6FC),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sm.w(4), vertical: sm.w(5)),
                                    child: Consumer<AppBookProvider>(
                                        builder: (context, data, child) {
                                      return Text('${data.getParticipent()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 16,
                                                  color: NeumorphicTheme
                                                          .isUsingDark(context)
                                                      ? Colors.white
                                                      : Color(0xff686868)),
                                          textAlign: TextAlign.center);
                                    }),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: sm.w(8)),
                                child: InkWell(
                                  onTap: () => data.changeParticipent(false),
                                  child: Card(
                                    color: NeumorphicTheme.isUsingDark(context)
                                        ? Color(0xffF4F6FC)
                                        : myBackGround,
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Padding(
                                      padding: EdgeInsets.all(sm.w(4)),
                                      child: Icon(Icons.remove,
                                          color: myRed, size: 16),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => data.changeParticipent(true),
                                child: Card(
                                  color: NeumorphicTheme.isUsingDark(context)
                                      ? Colors.white
                                      : myBackGround,
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Padding(
                                    padding: EdgeInsets.all(sm.w(4)),
                                    child:
                                        Icon(Icons.add, color: myRed, size: 16),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Divider(height: sm.h(6))),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Text('Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 14,
                                      color: myGrey,
                                      fontWeight: FontWeight.normal))),
                      Container(
                        height: 90,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0;
                                  i <
                                      data
                                          .getBookTableVerbose()
                                          ?.data
                                          ?.availableDates
                                          ?.length;
                                  i++)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          
                                          data.setSelectDate(context,i);
                                        }
                                          ,
                                        child: Card(
                                          color: !NeumorphicTheme.isUsingDark(
                                                  context)
                                              ? Colors.white
                                              : myBackGround,
                                          elevation: 12,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sm.w(4),
                                                horizontal: sm.w(6)),
                                            child: Text(
                                              "${data.getBookTableVerbose()?.data?.availableDates[i].day} (${dateFormat7.format(DateTime.parse(data.getBookTableVerbose()?.data?.availableDates[i].date))})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color:
                                                          data.getSelectDate() ==
                                                                  i
                                                              ? myRed
                                                              : myGrey,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Divider(height: sm.h(6))),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Text('Time',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: myGrey))),
                      Container(
                        height: 100,
                        child: ListView(
                            shrinkWrap: true,
                            
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0;
                                  i <
                                      context.watch<AppBookProvider>()
                                          .getBookTableVerbose()
                                          ?.data
                                          ?.slots
                                          ?.length;
                                  i++)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () => data.setSelectTime(i),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Card(
                                            color: myBackGround,
                                            elevation: 12,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40))),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 8),
                                              child: Text(
                                                  "${data.getBookTableVerbose()?.data?.slots[i].startTime.substring(0, 5)} ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          color:
                                                              data.getSelectTime() ==
                                                                      i
                                                                  ? myRed
                                                                  : myGrey,
                                                          fontSize: 12)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Divider()),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 8.0, left: sm.w(6), right: sm.w(6)),
                          child: Text('Occation',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 12, color: myGrey))),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(2)),
                        child: Center(
                          child: SizedBox(
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  color: myBackGround,
                                  depth: 8,
                                  lightSource: LightSource.top,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.all(Radius.circular(8.0)))),
                              margin:
                                  EdgeInsets.symmetric(horizontal: sm.w(10)),
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: data.selectedOccasion,
                                  hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(2)),
                                      child: Text(
                                        "Select Occasion",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12),
                                      )),
                                  underline: Container(),
                                  items: data
                                      .getOccasionList()
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: sm.w(2)),
                                            child: Text(value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12))));
                                  }).toList(),
                                  onChanged: (String value) =>
                                      data.selectedOccasion = value),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Divider(height: sm.h(6))),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Text('Detail',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: myGrey))),
                      Builder(
                          builder: (context) => Form(
                                key: RIKeys.josKeys29,
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: sm.h(4),
                                          left: sm.w(6),
                                          right: sm.w(6)),
                                      child: EditTextComponent(
                                          controller:
                                              data.acces[0].controller,
                                          title: "Name",
                                          valid: true,
                                          hint: "Enter Name",
                                          maxLines: 1,
                                          maxlen: 26,
                                          prefixIcon: 'name',
                                          error: data.acces[0].error,
                                          security: false)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: sm.h(4),
                                        left: sm.w(6),
                                        right: sm.w(6)),
                                    child: EditTextComponent(
                                        controller: data.acces[1].controller,
                                        title: "Mobile",
                                        hint: "Enter Mobile",
                                        maxLines: 1,
                                        maxlen: 10,
                                        myregex: emailAndMobileRegex,
                                        prefixIcon: 'phone',
                                        keyboardSet: TextInputType.phone,
                                        error: data.acces[1].error,
                                        valid: true,
                                        myOnChanged: (val)=>data.checkMobile(val),
                                        security: false),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: sm.h(4),
                                        left: sm.w(6),
                                        right: sm.w(6)),
                                    child: EditTextComponent(
                                        controller: data.acces[2].controller,
                                        title: "Special Notes",
                                        maxlen: 200,
                                        hint: "Enter Special Notes",
                                        error: data.acces[2].error,
                                        maxLines: 8,
                                        security: false),
                                  ),
                                ]),
                              )),
                      Visibility(
                        visible:context.watch<AppBookProvider>().acces[1].controller.text.trim().length==10,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: sm.h(4), horizontal: sm.h(10)),
                          child: data.getSubmitCalled()
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
                                          BorderRadius.all(
                                              Radius.circular(24.0)))),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: sm.w(10)),
                                  onPressed: () =>
                                      data.funSubmitBooking(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 16),
                                  child: Center(
                                    child: Text("Done",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: myRed)),
                                  ),
                                ),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
  
  },));
  
  }

  Widget mySlotSelector(_data, context) {
    return Container(
      width: sm.w(100),
      height: sm.h(8),
      decoration: BoxDecoration(color: Colors.transparent),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var temp in _data.slotList)
            InkWell(
              onTap: () {
                for (var temp in _data.slotList) 
                  temp.selected = false;
                
                temp.selected = true;
              },
              child: Padding(
                padding: EdgeInsets.only(
                    right: sm.w(1), top: sm.h(2), bottom: sm.h(2)),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 8,
                      lightSource: LightSource.top,
                      color: Colors.white,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(8.0)))),
                  margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                      child: Text(temp.slot,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color:
                                  temp.selected ? Colors.green : Colors.grey)),
                    ),
                  ),
                ),
              ),
            ),
        ]
      ),
    );
  }
}
