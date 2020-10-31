import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:Favorito/ui/waitlist/ManualWaitList.dart';
import 'package:Favorito/ui/waitlist/waitlistSettingContrller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class Waitlist extends StatefulWidget {
  @override
  Waitlists createState() => Waitlists();
}

class Waitlists extends State<Waitlist> {
  WaitlistListModel waitlistData;

  @override
  void initState() {
    super.initState();
  }

  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
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
          title: Text(waitlist, style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManualWaitList()))
                      .whenComplete(() => getPageData());
                }),
            IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    height: 20),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaitListSetting())))
          ],
        ),
        body: FutureBuilder<WaitlistListModel>(
          future: WebService.funGetWaitlist(),
          builder: (BuildContext context,
              AsyncSnapshot<WaitlistListModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                waitlistData = snapshot.data;
                return Container(
                  margin:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                  child: RefreshIndicator(
                    onRefresh: () => getPageData(),
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
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: sm.scaledWidth(10),
                                        child: Text(va.noOfPerson.toString(),
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      SizedBox(
                                        width: sm.scaledWidth(45),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                va.name.toLowerCase(),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "Walk-in | ${va.walkinAt}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: AutoSizeText(
                                                va.specialNotes,
                                                style: TextStyle(color: myGrey),
                                                maxLines: 1,
                                                minFontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                iconSize: sm.scaledWidth(8),
                                                icon: Icon(Icons.call,
                                                    color: myRed),
                                                onPressed: () => _callPhone(
                                                    'tel:${va.contact}'),
                                              ),
                                              IconButton(
                                                iconSize: sm.scaledWidth(8),
                                                icon: Icon(
                                                    FontAwesomeIcons.trashAlt,
                                                    size: 16,
                                                    color: myRed),
                                                onPressed: () => waitListDelete(
                                                    va.id, index),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  iconSize: sm.scaledWidth(8),
                                                  icon: Icon(Icons.check_circle,
                                                      color:
                                                          va.waitlistStatus ==
                                                                  "accepted"
                                                              ? myGrey
                                                              : myRed),
                                                  onPressed: () {
                                                    if (va.waitlistStatus !=
                                                        "accepted")
                                                      UpdateWaitList(
                                                          "accepted", va.id);
                                                  }),
                                              IconButton(
                                                  iconSize: sm.scaledWidth(8),
                                                  icon: Icon(Icons.close,
                                                      color:
                                                          va.waitlistStatus ==
                                                                  "rejected"
                                                              ? myGrey
                                                              : myRed),
                                                  onPressed: () {
                                                    if (va.waitlistStatus !=
                                                        "rejected")
                                                      UpdateWaitList(
                                                          "rejected", va.id);
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

  Widget _popupBodyShowDetail(WaitlistModel model, int index) {
    return Container(
        child: WaitListDetail(
            waitlistData: model,
            action: UpdateWaitList,
            delete: waitListDelete,
            index: index));
  }

  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }

  UpdateWaitList(String str, int id) async {
    await WebService.funWaitlistUpdateStatus({"id": id, "status": str})
        .then((value) {
      print(value.message);
      if (value.status == "success") {
        WebService.funGetWaitlist().then((value) {
          setState(() {});
          return value;
        });
      }
    });
  }

  getPageData() async {
    await WebService.funGetWaitlist().then((value) {
      if (value.status == "succcess") {
        setState(() {
          waitlistData = value;
        });
      }
    });
  }

  waitListDelete(int id, int index) {
    WebService.funWaitlistDelete({"waitlist_id": id}).then((value) {
      setState(() => waitlistData.data.removeAt(index));
    });
  }
}
