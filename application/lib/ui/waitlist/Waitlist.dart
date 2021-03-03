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

class Waitlist extends StatefulWidget {
  @override
  Waitlists createState() => Waitlists();
}

class Waitlists extends State<Waitlist> {
  WaitlistListModel waitlistData;

  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(waitlist,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Gilroy-Bold')),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManualWaitList()))
                      .whenComplete(() => getPageData());
                }),
            IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    height: 26),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WaitListSetting())))
          ],
        ),
        body: FutureBuilder<WaitlistListModel>(
          future: WebService.funGetWaitlist(context),
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
                    onRefresh: () async {
                      setState(() {});
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
                                            va.name.toLowerCase(),
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
                                            "Walk-in | ${va.walkinAt}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: AutoSizeText(
                                            va?.specialNotes ?? '',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            iconSize: sm.w(8),
                                            icon:
                                                Icon(Icons.call, color: myRed),
                                            onPressed: () =>
                                                _callPhone('tel:${va.contact}'),
                                          ),
                                          IconButton(
                                              iconSize: sm.w(8),
                                              icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  size: 16,
                                                  color: myRed),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  child: new AlertDialog(
                                                    title: const Text(
                                                        "Please confirm"),
                                                    content: Text(
                                                        'Are you sure you want to delete ?'),
                                                    actions: [
                                                      new FlatButton(
                                                          child:
                                                              const Text("Ok"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            waitListDelete(
                                                                va.id, index);
                                                          }),
                                                      new FlatButton(
                                                        child: const Text(
                                                            "Cancel"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                      new FlatButton(
                                                        child: const Text(''),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
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
                                                if (va.waitlistStatus !=
                                                    "accepted")
                                                  UpdateWaitList(
                                                      "accepted", va.id);
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
            top: sm.h(30),
            left: sm.w(10),
            right: sm.w(10),
            bottom: sm.h(30),
            child: PopupContent(
                content: Scaffold(
                    resizeToAvoidBottomPadding: false, body: widget))));
  }

  Widget _popupBodyShowDetail(WaitlistModel model, int index) {
    return Container(
        child: WaitListDetail(
            waitlistData: model,
            action: UpdateWaitList,
            delete: waitListDelete,
            index: index));
  }

  _callPhone(String phone) async => await canLaunch(phone)
      ? await launch(phone)
      : throw 'Could not Call Phone';

  UpdateWaitList(String str, int id) async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funWaitlistUpdateStatus(
              {"waitlist_id": id, "status": str}, context)
          .then((value) {
        print(value.message);
        if (value.status == "success") {
          WebService.funGetWaitlist(context).then((value) {
            setState(() {});
            return value;
          });
        }
      });
  }

  getPageData() async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funGetWaitlist(context).then((value) {
        if (value.status == "succcess") {
          setState(() {
            waitlistData = value;
          });
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
}
