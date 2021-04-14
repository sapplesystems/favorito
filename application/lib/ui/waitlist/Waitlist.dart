import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:Favorito/ui/waitlist/ManualWaitList.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/waitlist/WaitlistDetail.dart';
import 'package:Favorito/ui/waitlist/waitListSetting.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';
import '../../utils/Extentions.dart';

class Waitlist extends StatefulWidget {
  @override
  Waitlists createState() => Waitlists();
}

class Waitlists extends State<Waitlist> {
  WaitlistListModel waitlistData;
  bool isFirst = true;
  GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        key: key,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(waitlist,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Gilroy-Bold')),
          actions: [
            IconButton(
                icon: Icon(Icons.add_circle_outline, size: 30),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManualWaitList()))
                      .whenComplete(() => setState(() {
                            isFirst = true;
                          }));
                }),
            IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    height: 26),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaitListSetting())))
          ],
        ),
        body: FutureBuilder<WaitlistListModel>(
          future: getData(),
          builder: (BuildContext context,
              AsyncSnapshot<WaitlistListModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text(''));
              else {
                waitlistData = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        isFirst = true;
                      });
                    },
                    child: ListView.builder(
                        itemCount: waitlistData.data == null
                            ? 0
                            : waitlistData.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var va = waitlistData.data[index];
                          return InkWell(
                            onTap: () {
                              showPopup(
                                  context, _popupBodyShowDetail(va, index));
                            },
                            child: Card(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: sm.w(12),
                                    child: Text(va.noOfPerson.toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  SizedBox(
                                    width: sm.w(43),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: AutoSizeText(
                                              va.bookedBy
                                                      ?.toLowerCase()
                                                      ?.capitalize() ??
                                                  '',
                                              minFontSize: 22,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "Walk-in | ${va.walkinAt ?? ''}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: AutoSizeText(
                                              va.specialNotes ?? '',
                                              style: TextStyle(color: myGrey),
                                              maxLines: 1,
                                              minFontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ]),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        IconButton(
                                          iconSize: sm.w(8),
                                          icon: SvgPicture.asset(
                                              'assets/icon/call.svg',
                                              height: sm.w(7)),
                                          onPressed: () => _callPhone(
                                              'tel:${va.contact ?? ''}'),
                                        ),
                                        IconButton(
                                            iconSize: sm.w(8),
                                            icon: SvgPicture.asset(
                                                'assets/icon/delete.svg',
                                                height: sm.w(6)),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                            '\t\t\t\t\tAre you sure you want to delete ?',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Gilroy-Medium'),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TextButton(
                                                                  child: Text(
                                                                      "Ok",
                                                                      style: TextStyle(
                                                                          color:
                                                                              myRed,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Gilroy-Medium')),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    waitListDelete(
                                                                        va.id ??
                                                                            0,
                                                                        index);
                                                                  }),
                                                              InkWell(
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color:
                                                                          myRed,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Gilroy-Medium'),
                                                                ),
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            })
                                      ]),
                                      Row(
                                        children: [
                                          IconButton(
                                              iconSize: sm.w(8),
                                              icon: Icon(Icons.check_circle,
                                                  color: va.waitlistStatus ==
                                                          "accepted"
                                                      ? myGrey
                                                      : myRed),
                                              onPressed: () {
                                                print(
                                                    "aaaaa${va?.waitlistStatus ?? "d"}");

                                                if (va.waitlistStatus !=
                                                    "accepted")
                                                  UpdateWaitList(
                                                      "accepted", va.id ?? 0);
                                              }),
                                          IconButton(
                                              iconSize: sm.w(8),
                                              icon: Icon(Icons.close,
                                                  color: va.waitlistStatus ==
                                                          "rejected"
                                                      ? myGrey
                                                      : myRed),
                                              onPressed: () {
                                                if (va.waitlistStatus !=
                                                    "rejected")
                                                  UpdateWaitList(
                                                      "rejected", va.id ?? '');
                                              })
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                          );
                        }),
                  ),
                );
              }

              // snapshot.data  :- get your object which is pass from your downloadData() function
            }
          },
        ));
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
        context,
        PopupLayout(
            top: sm.h(30),
            left: sm.w(10),
            right: sm.w(10),
            bottom: sm.h(30),
            child: PopupContent(content: Scaffold(body: widget))));
  }

  Widget _popupBodyShowDetail(WaitlistModel model, int index) {
    return WaitListDetail(
        waitlistData: model,
        action: UpdateWaitList,
        delete: waitListDelete,
        index: index);
  }

  _callPhone(String phone) async => await canLaunch(phone)
      ? await launch(phone)
      : throw 'Could not Call Phone';

  UpdateWaitList(String str, int id) async {
    print("aaaa1");
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funWaitlistUpdateStatus(
              {"waitlist_id": id, "status": str}, context)
          .then((value) {
        print(value.message);
        if (value.status == "success") {
          isFirst = true;
          setState(() {});
        }
      });
  }

  waitListDelete(int id, int index) async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funWaitlistDelete({"waitlist_id": id}, context)
          .then((value) {
        setState(() => waitlistData.data.removeAt(index));
      });
  }

  Future<WaitlistListModel> getData() {
    if (isFirst) {
      isFirst = false;
      return WebService.funGetWaitlist(context);
    }
  }
}
