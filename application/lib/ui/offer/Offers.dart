import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/offer/CreateOffer.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class Offers extends StatefulWidget {
  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offers> {
  String _selectedOfferType;

  List<OfferDataModel> activeNewUserOfferList = [];
  List<OfferDataModel> inactiveNewUserOfferList = [];
  List<OfferDataModel> activeCurrentUserOfferList = [];
  List<OfferDataModel> inactiveCurrentUserOfferList = [];

  List<OfferDataModel> newUserOfferInputList = [];
  List<OfferDataModel> currentUserOfferInputList = [];

  List<String> offerTypeList = ['Activated', 'Inactive'];

  @override
  void initState() {
    initializeIntitialValues();
    super.initState();
  }

  initializeIntitialValues() async {
    await WebService.funGetOfferData(context).then((value) {
      setState(() {
        _selectedOfferType = 'Activated';

        activeNewUserOfferList.clear();
        inactiveNewUserOfferList.clear();
        activeCurrentUserOfferList.clear();
        inactiveCurrentUserOfferList.clear();
        for (var temp in value.data) {
          if (temp.offerStatus == 'Activated' &&
              temp.offerType == 'Current Offer') {
            activeCurrentUserOfferList.add(temp);
          } else if (temp.offerStatus == 'Inactive' &&
              temp.offerType == 'Current Offer') {
            inactiveCurrentUserOfferList.add(temp);
          } else if (temp.offerStatus == 'Activated' &&
              temp.offerType == 'New User Offer') {
            activeNewUserOfferList.add(temp);
          } else {
            inactiveNewUserOfferList.add(temp);
          }
        }

        newUserOfferInputList.clear();
        for (var data in activeNewUserOfferList) {
          newUserOfferInputList.add(data);
        }
        currentUserOfferInputList.clear();
        for (var data in activeCurrentUserOfferList) {
          currentUserOfferInputList.add(data);
        }
      });
    });
  }

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
          title: Text(
            "Offers List",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icon/addWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateOffer(
                              offerData: null,
                            ))).whenComplete(() => initializeIntitialValues());
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: sm.scaledWidth(20),
                    right: sm.scaledWidth(20),
                    top: 8.0,
                    bottom: 16.0),
                child: DropdownSearch<String>(
                  validator: (v) => v == '' ? "required field" : null,
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  selectedItem: _selectedOfferType,
                  items: offerTypeList != null ? offerTypeList : null,
                  label: "Offer Type",
                  hint: "Please Select Offer Type",
                  showSearchBox: false,
                  onChanged: (value) {
                    setState(() {
                      _selectedOfferType = value;
                      print(_selectedOfferType);
                      if (_selectedOfferType == offerTypeList[0].trim()) {
                        newUserOfferInputList.clear();
                        for (var data in activeNewUserOfferList) {
                          newUserOfferInputList.add(data);
                        }
                        currentUserOfferInputList.clear();
                        for (var data in activeCurrentUserOfferList) {
                          currentUserOfferInputList.add(data);
                        }
                      } else {
                        newUserOfferInputList.clear();
                        for (var data in inactiveNewUserOfferList) {
                          newUserOfferInputList.add(data);
                        }
                        currentUserOfferInputList.clear();
                        for (var data in inactiveCurrentUserOfferList) {
                          currentUserOfferInputList.add(data);
                        }
                      }
                    });
                  },
                ),
              ),
              Text("New User Offers",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Container(
                  height: sm.scaledHeight(34),
                  child: ListView.builder(
                      itemCount: newUserOfferInputList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOffer(
                                              offerData:
                                                  newUserOfferInputList[index],
                                            )))
                                .whenComplete(() => initializeIntitialValues());
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0),
                                  child: Text(
                                    newUserOfferInputList[index].offerTitle,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 16.0),
                                  child: AutoSizeText(
                                    newUserOfferInputList[index]
                                        .offerDescription,
                                    maxLines: 2,
                                    minFontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 16.0, bottom: 16.0),
                                      child: Text(
                                        "Activated : ${newUserOfferInputList[index].totalActivated}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 16.0,
                                          bottom: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Redeemed : ${newUserOfferInputList[index].totalRedeemed}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Current Offers",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              Container(
                  height: sm.scaledHeight(35),
                  child: ListView.builder(
                      itemCount: currentUserOfferInputList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateOffer(
                                          offerData:
                                              currentUserOfferInputList[index],
                                        ))).whenComplete(
                                () => initializeIntitialValues());
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 16.0),
                                  child: Text(
                                    currentUserOfferInputList[index].offerTitle,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 16.0),
                                  child: AutoSizeText(
                                    currentUserOfferInputList[index]
                                        .offerDescription,
                                    maxLines: 2,
                                    minFontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 16.0, bottom: 16.0),
                                      child: Text(
                                        "Activated : ${currentUserOfferInputList[index].totalActivated}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 16.0,
                                          bottom: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Redeemed : ${currentUserOfferInputList[index].totalRedeemed}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ));
  }
}
