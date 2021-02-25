import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/ui/offer/CreateOffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewMore extends StatelessWidget {
  List<OfferDataModel> data;
  String val;
  ViewMore({this.data, this.val});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop()),
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
                val == 'new' ? 'New User Offers' : 'Current User Offers',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy-Bold',
                    fontSize: 26))),
        body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateOffer(
                                offerData: data[index],
                              ))).whenComplete(() => Navigator.pop(context));
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                        child: Text(
                          data[index].offerTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                        // child: AutoSizeText(
                        child: Text(
                          data[index].offerDescription,
                          maxLines: 2,
                          // minFontSize: 14,

                          style: TextStyle(
                              fontFamily: 'Gilroy-Medium', fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 16.0, bottom: 16.0),
                            child: Text(
                              "Activated : ${data[index].totalActivated}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                left: 16.0,
                                bottom: 16.0,
                                right: 16.0),
                            child: Text(
                              "Redeemed : ${data[index].totalRedeemed}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
