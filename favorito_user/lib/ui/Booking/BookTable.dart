import 'package:bot_toast/bot_toast.dart';
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
  AppBookProvider vaTrue;
  var fut;
  bool isFirst = true;
  bool _FormValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppBookProvider>(context, listen: true);
    if (isFirst) {
      fut = vaTrue
        ..setIsVerboseCall(true)
        ..bookingVerbose(context);
      isFirst = false;
    }
    return Scaffold(
        backgroundColor: myBackGround,
        body: vaTrue.getIsVerboseCall()
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
                    backgroundColor: myBackGround,
                    appBar: AppBar(
                      backgroundColor: myBackGround,
                      elevation: 0,
                      leading: IconButton(
                          color: Colors.black,
                          iconSize: 45,
                          icon: Icon(Icons.keyboard_arrow_left),
                          onPressed: () => Navigator.of(context).pop()),
                      title: Text("Book Table",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ),
                    key: RIKeys.josKeys19,
                    body: ListView(shrinkWrap: true, children: [
                      Text(
                          vaTrue
                                  .getBookTableVerbose()
                                  ?.data
                                  ?.businessName
                                  ?.capitalize() ??
                              "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18)),
                      Padding(
                          padding: EdgeInsets.only(top: sm.h(2), left: sm.w(6)),
                          child: Row(children: [
                            Text('How many guests?',
                                style: TextStyle(color: myGrey))
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
                                      color: myBackGround),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sm.w(4), vertical: sm.w(5)),
                                    child: Consumer<AppBookProvider>(
                                        builder: (context, data, child) {
                                      return Text('${vaTrue.getParticipent()}',
                                          style: TextStyle(
                                              color: Color(0xff686868)),
                                          textAlign: TextAlign.center);
                                    }),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: sm.w(8)),
                                child: InkWell(
                                  onTap: () => vaTrue.changeParticipent(false),
                                  child: Card(
                                    color: myBackGround,
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
                                onTap: () => vaTrue.changeParticipent(true),
                                child: Card(
                                  color: myBackGround,
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
                          child: Text('Date', style: TextStyle(color: myGrey))),
                      Container(
                        height: 90,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0;
                                  i <
                                      vaTrue
                                          .getBookTableVerbose()
                                          ?.data
                                          ?.availableDates
                                          ?.length;
                                  i++)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            vaTrue.setSelectDate(context, i),
                                        child: Card(
                                          color: myBackGround,
                                          elevation: 12,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sm.w(4),
                                                horizontal: sm.w(6)),
                                            child: Text(
                                              "${vaTrue.getBookTableVerbose()?.data?.availableDates[i].day} (${dateFormat7.format(DateTime.parse(vaTrue.getBookTableVerbose()?.data?.availableDates[i].date))})",
                                              style: TextStyle(
                                                  color:
                                                      vaTrue.getSelectDate() ==
                                                              i
                                                          ? myRed
                                                          : myGrey),
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
                          child: Text('Time', style: TextStyle(color: myGrey)))   ,                   Container(
                        height: 100,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0;
                                  i <
                                      vaTrue
                                          .getBookTableVerbose()
                                          ?.data
                                          ?.slots
                                          ?.length;
                                  i++)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () => vaTrue.setSelectTime(i),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Card(
                                            color: myBackGround,
                                            elevation: 12,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 8),
                                              child: Text(
                                                "${vaTrue.getBookTableVerbose()?.data?.slots[i].startTime.substring(0, 5)} ",
                                                style: TextStyle(
                                                    color:
                                                        vaTrue.getSelectTime() ==
                                                                i
                                                            ? myRed
                                                            : myGrey),
                                              ),
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
                              style: TextStyle(color: myGrey))),
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
                                  value: vaTrue.selectedOccasion,
                                  hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(2)),
                                      child: Text("Select Occasion")),
                                  underline: Container(),
                                  items: vaTrue
                                      .getOccasionList()
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: sm.w(2)),
                                            child: Text(value)));
                                  }).toList(),
                                  onChanged: (String value) =>
                                      vaTrue.selectedOccasion = value),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child: Divider(height: sm.h(6))),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(6)),
                          child:
                              Text('Detail', style: TextStyle(color: myGrey))),
                      Builder(
                          builder: (context) => Form(
                                key: _formKey,
                                autovalidate: _FormValidate,
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: sm.h(4),
                                          left: sm.w(6),
                                          right: sm.w(6)),
                                      child: EditTextComponent(
                                          controller:
                                              vaTrue.acces[0].controller,
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
                            vertical: sm.h(4), horizontal: sm.h(10)),
                        child: vaTrue.getSubmitCalled()
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: myRed,
                                    valueColor: AlwaysStoppedAnimation(myGrey),
                                    strokeWidth: 4),
                              )
                            : NeumorphicButton(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 4,
                                    lightSource: LightSource.topLeft,
                                    color: myBackGround,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.all(
                                            Radius.circular(24.0)))),
                                margin:
                                    EdgeInsets.symmetric(horizontal: sm.w(10)),
                                onPressed: () =>
                                    vaTrue.funSubmitBooking(context),
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
                    ]),
                  ),
                ),
              ));
  }

  Widget mySlotSelector(_data) {
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
                for (var temp in _data.slotList) {
                  temp.selected = false;
                }
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
                          style: TextStyle(
                              color:
                                  temp.selected ? Colors.green : Colors.grey)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
