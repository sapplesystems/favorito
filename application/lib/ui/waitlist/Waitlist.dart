import 'package:url_launcher/url_launcher.dart';
import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/booking/ManualBooking.dart';
import 'package:Favorito/ui/waitlist/WaitlistDetail.dart';
import 'package:Favorito/ui/waitlist/waitListSetting.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';

class Waitlist extends StatefulWidget {
  @override
  _Waitlist createState() => _Waitlist();
}

class _Waitlist extends State<Waitlist> {
  WaitlistListModel waitlistData;

  @override
  void initState() {
    WebService.funGetWaitlist().then((value) {
      setState(() {
        waitlistData = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            waitlist,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManualBooking()));
              },
            ),
            IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    height: 20),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaitListSetting())))
          ],
        ),
        body: Container(
          height: sm.scaledHeight(100),
          decoration: BoxDecoration(color: myBackGround),
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
          child: ListView.builder(
              itemCount: waitlistData == null ? 0 : waitlistData.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    showPopup(context,
                        _popupBodyShowDetail(waitlistData.data[index]));
                  },
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Container(
                        height: sm.scaledHeight(12),
                        margin: EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sm.scaledWidth(10),
                                child: Text(
                                  waitlistData.data[index].noOfPerson
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                width: sm.scaledWidth(45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        waitlistData.data[index].name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Walk-in | ${waitlistData.data[index].walkinAt}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: AutoSizeText(
                                        waitlistData.data[index].specialNotes,
                                        maxLines: 1,
                                        minFontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.call, color: myRed),
                                        onPressed: () {
                                          _callPhone(
                                              'tel:${waitlistData.data[index].contact}');
                                        },
                                      ),
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.delete, color: myRed),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.check_circle,
                                            color: myRed),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.close, color: myRed),
                                        onPressed: () {},
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                );
              }),
        ));
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(30),
        left: sm.scaledWidth(10),
        right: sm.scaledWidth(10),
        bottom: sm.scaledHeight(30),
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBodyShowDetail(WaitlistModel model) {
    return Container(child: WaitListDetail(waitlistData: model));
  }

  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}
