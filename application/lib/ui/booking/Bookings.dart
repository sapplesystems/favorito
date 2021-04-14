import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/model/booking/SlotData.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/booking/BokingDetail.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/ui/booking/BookingSetting.dart';
import 'package:Favorito/ui/booking/ManualBooking.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/SizeManager.dart';

class Bookings extends StatelessWidget {
  BookingProvider vaTrue;
  BookingProvider vafalse;
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BookingProvider>(context, listen: true);
    vafalse = Provider.of<BookingProvider>(context, listen: false);
    print(
        'dcdc${dateFormat1.format(vaTrue.getInitialDate().subtract(Duration(days: 1)))}');
    print('dcdc${dateFormat1.format(DateTime.now())}');
    return Scaffold(
        key: RIKeys.josKeys6,
        appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text("Bookings", style: titleStyle),
            actions: [
              Visibility(
                visible: vaTrue.getTotalBookingDays() > 0,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 34),
                  onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManualBooking()))
                      .whenComplete(() => vaTrue.getBookingData()),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    alignment: Alignment.center),
                onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingSetting()))
                    .whenComplete(() => vaTrue.getPageData()),
              )
            ]),
        body: vaTrue.blm.slots == null
            ? Center(child: Text('Please wait its loading...'))
            : RefreshIndicator(
                onRefresh: () async {
                  vaTrue.getBookingData();
                },
                child: ListView(shrinkWrap: true, children: [
                  InkWell(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate:
                                  vaTrue.getInitialDate() ?? DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 90)),
                              lastDate: DateTime.now().add(Duration(days: 10)))
                          .then((_val) {
                        vaTrue.setInitialDate(dateFormat1.format(_val));
                      });
                    },
                    child: Container(
                        width: sm.w(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: myGreyLight2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(
                            left: sm.w(36), right: sm.w(36), top: sm.w(6)),
                        padding: EdgeInsets.symmetric(vertical: sm.h(.8)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  dateFormat1.format(vaTrue.getInitialDate()) ==
                                          dateFormat1.format(DateTime.now())
                                      ? 'Today'
                                      : dateFormat6.format(
                                              vaTrue.getInitialDate()) ??
                                          'Select',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                              SvgPicture.asset('assets/icon/triangle_down.svg')
                            ])),
                  ),
                  Container(
                    height: sm.h(30),
                    padding: EdgeInsets.only(top: 10),
                    margin: EdgeInsets.symmetric(horizontal: sm.w(4)),
                    child: GridView.builder(
                      itemCount: vaTrue.blm.slots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: sm.w(3),
                          mainAxisSpacing: sm.h(0)),
                      itemBuilder: (BuildContext context, int index) {
                        int _selected = 0;
                        return InkWell(
                          onTap: () {
                            print('dfdf$index');
                            vaTrue.setSelectedSlotIndex(index);
                            vaTrue.setSelectedSlot(index);
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:

                                        // vaTrue.blm.slots[index].slotData
                                        //             .length <
                                        //         vaTrue.blm.perSlot
                                        vaTrue.getSelectedSlotIndex() == index
                                            ? myGrey
                                            : myRed,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
                                  ),
                                  width: sm.w(10),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.4, vertical: 8.0),
                                    child: Center(
                                      child: Text(
                                          "${vaTrue.blm?.slots[index]?.slotStart ?? '00:00'}-${vaTrue.blm?.slots[index]?.slotEnd ?? '00:00'}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Gilroy-Regular',
                                            backgroundColor:
                                                vaTrue.getSelectedSlotIndex() ==
                                                        index
                                                    ? myGrey
                                                    : myRed,
                                            // vaTrue
                                            //             .blm
                                            //             .slots[index]
                                            //             .slotData
                                            //             .length <
                                            //         vaTrue.blm.perSlot
                                            //     ? myRed
                                            //     : myGrey
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sm.w(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0))),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          "${vaTrue.blm.slots[index].slotData.length ?? 0}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Gilroy-Medium',
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white)),
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: vaTrue.blm.slots.length < 4 ? sm.h(50) : null,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("User Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.w700)),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: new NeverScrollableScrollPhysics(),
                            itemCount: vaTrue.blm.slots.length != 0
                                ? vaTrue.blm.slots[vaTrue.getSelectedSlot()]
                                    .slotData.length
                                : 0,
                            itemBuilder: (BuildContext context, int _index) {
                              var va = vaTrue
                                  .blm
                                  .slots[vaTrue.getSelectedSlot()]
                                  .slotData[_index];

                              var vv =
                                  "${dateFormat6.format(vaTrue.getInitialDate())} | ${vaTrue?.blm?.slots[vaTrue.getSelectedSlot()].slotStart?.substring(0, 5)} - ${vaTrue.blm?.slots[vaTrue.getSelectedSlot()].slotEnd.substring(0, 5)} | ${va?.noOfPerson} ${(va?.noOfPerson ?? 0) > 1 ? 'persons' : 'person'}";
                              return Card(
                                  borderOnForeground: true,
                                  child: InkWell(
                                    onTap: () => showPopup(
                                        context, va, _popupBody(va, vv)),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            vv,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManualBooking(
                                                                  data: va)))
                                                  .whenComplete(() =>
                                                      vaTrue.getBookingData());
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: myRed,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            va.name??'',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Gilroy-Regular',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: AutoSizeText(va.specialNotes??'',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 12,
                                                maxFontSize: 14),
                                          ),
                                          trailing: InkWell(
                                            onTap: () =>
                                                launch("tel://${va.contact}"),
                                            child: Container(
                                              decoration: bd1Red,
                                              padding: EdgeInsets.all(6),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.white,
                                                size: 26,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ),
                                  ));
                            }),
                      ],
                    ),
                  ),
                ]),
              ));
  }

  showPopup(BuildContext context, va, Widget widget,
      {BuildContext popupContext}) {
    double i = (va?.specialNotes?.length??0) <= 500
        ? 30
        : (((va?.specialNotes?.length??0) > 500) && ((va?.specialNotes?.length??0) <= 1000))
            ? 20
            : 12;
    print('sss$i');
    Navigator.push(
      context,
      PopupLayout(
          top: sm.h(i),
          left: sm.w(10),
          right: sm.w(10),
          bottom: sm.h(i),
          child: PopupContent(content: widget)),
    );
  }

  Widget _popupBody(SlotData model, String _vv) => BokingDetail(
      action: () {
        // Navigator.push(
        //         vaTrue.key.currentContext,
        //         MaterialPageRoute(
        //             builder: (context) => ManualBooking(data: model)))
        //     .whenComplete(() => vaTrue.getBookingData());
      },
      delete: vaTrue.deleteBooking,
      waitlistData: model,
      heading: _vv,
      isSmall: false);
}
