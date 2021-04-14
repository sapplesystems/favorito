import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:flutter_svg/svg.dart';
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Scrollbar(
        showTrackOnHover: true,
        child: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  "${widget.waitlistData?.waitlistDate ?? ''} |${widget.waitlistData?.waitlistStatus ?? ''} ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey))),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.waitlistData?.bookedBy ?? '',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Walk-in | ${widget.waitlistData?.walkinAt ?? ''}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    widget.waitlistData.noOfPerson == 1
                        ? "${widget.waitlistData?.noOfPerson ?? ''} Person"
                        : "${widget.waitlistData?.noOfPerson ?? ''} Persons",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))
          ]),
          Padding(
              padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: AutoSizeText(
                widget.waitlistData?.specialNotes ?? '',
                // maxLines: 4,
                minFontSize: 16,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                iconSize: sm.w(8),
                icon: SvgPicture.asset('assets/icon/call.svg', height: sm.w(7)),
                onPressed: () =>
                    _callPhone('tel:${widget.waitlistData.contact}'),
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
                icon:
                    SvgPicture.asset('assets/icon/delete.svg', height: sm.w(6)),
                onPressed: () {
                  widget.delete(widget.waitlistData.id, widget.index);
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  _callPhone(String phone) async {
    (await canLaunch(phone))
        ? await launch(phone)
        : throw 'Could not Call Phone';
  }
}
