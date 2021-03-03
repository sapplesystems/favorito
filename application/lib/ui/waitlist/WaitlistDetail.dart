import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class WaitListDetail extends StatefulWidget {
  WaitlistModel waitlistData;
  Function action;
  Function delete;
  int index;

  WaitListDetail({this.waitlistData, this.action, this.delete, this.index});

  @override
  _WaitListDetail createState() => _WaitListDetail();
}

class _WaitListDetail extends State<WaitListDetail> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: Colors.white,
        body:Padding(
          padding: EdgeInsets.all(8.0),
      child: Scrollbar(
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    "${widget.waitlistData.waitlistDate} |${widget.waitlistData.waitlistStatus} ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey))),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(widget.waitlistData.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Walk-in | ${widget.waitlistData.walkinAt}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.waitlistData.noOfPerson == 1
                        ? "${widget.waitlistData.noOfPerson} Person"
                        : "${widget.waitlistData.noOfPerson} Persons",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                  )
                )
              ]
            ),
            Expanded(flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AutoSizeText(
                  widget.waitlistData.specialNotes,
                  maxLines: 4,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis
                    ,style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: sm.w(8),
                    icon: Icon(Icons.call),
                    onPressed: () {
                      _callPhone('tel:${widget.waitlistData.contact}');
                    },
                  ),
                  IconButton(
                      iconSize: sm.w(8),
                      icon: Icon(Icons.check_circle),
                      onPressed: () {
                        widget.action("accepted", widget.waitlistData.id);
                        Navigator.pop(context);
                      }),
                  IconButton(
                      iconSize: sm.w(8),
                      icon: Icon(Icons.close),
                      onPressed: () {
                        widget.action("rejected", widget.waitlistData.id);
                        Navigator.pop(context);
                      }),
                  IconButton(
                    iconSize: sm.w(8),
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      widget.delete(widget.waitlistData.id, widget.index);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _callPhone(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}
