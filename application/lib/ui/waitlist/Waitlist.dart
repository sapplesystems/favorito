import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/ui/waitlist/WaitlistDetail.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class Waitlist extends StatefulWidget {
  @override
  _Waitlist createState() => _Waitlist();
}

class _Waitlist extends State<Waitlist> {
  List<WaitlistModel> waitlistData = [];

  @override
  void initState() {
    setState(() {
      WaitlistModel model1 = WaitlistModel();
      model1.tableCapacity = '5';
      model1.name = 'John Hopkins';
      model1.type = 'Wak-In';
      model1.time = '13:40';
      model1.notes =
          "Here is the use notes to show the important part gf agf gsd f gfahgdhagfdg gfhagbdfh gajhfghjfjha hvjhf sgf ae ygaygayg agyfg";
      model1.date = "12 Jan";
      model1.slot = "13:00-14:00";
      waitlistData.add(model1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Notification",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icon/addWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                // do something
              },
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: Container(
          height: sm.scaledHeight(100),
          margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
          child: ListView.builder(
              itemCount: waitlistData.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    showPopup(context, _popupBody(waitlistData[index]));
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
                                  waitlistData[index].tableCapacity,
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
                                        waitlistData[index].name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "${waitlistData[index].type} | ${waitlistData[index].time}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: AutoSizeText(
                                        waitlistData[index].notes,
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
                                        icon: Icon(Icons.call),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.delete),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.check_circle),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.close),
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

  Widget _popupBody(WaitlistModel model) {
    return Container(child: WaitListDetail(waitlistData: model));
  }
}
