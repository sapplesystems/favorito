import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class WaitListDetail extends StatefulWidget {
  WaitlistModel waitlistData;
  WaitListDetail({this.waitlistData});

  @override
  _WaitListDetail createState() => _WaitListDetail();
}

class _WaitListDetail extends State<WaitListDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "${widget.waitlistData.date} | ${widget.waitlistData.slot}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.waitlistData.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "${widget.waitlistData.type} | ${widget.waitlistData.time}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.waitlistData.tableCapacity == '1'
                      ? "${widget.waitlistData.tableCapacity} Person"
                      : "${widget.waitlistData.tableCapacity} Persons",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                widget.waitlistData.notes,
                maxLines: 4,
                minFontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: context.percentWidth * 8,
                  icon: Icon(Icons.call),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: context.percentWidth * 8,
                  icon: Icon(Icons.check_circle),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: context.percentWidth * 8,
                  icon: Icon(Icons.close),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: context.percentWidth * 8,
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
