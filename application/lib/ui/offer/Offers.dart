import 'package:Favorito/model/offer/OfferDataModel.dart';
import 'package:Favorito/ui/offer/CreateOffer.dart';
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
    setState(() {
      OfferDataModel model1 = OfferDataModel();
      model1.title = 'Buy 1 Get 1 Free';
      model1.description = 'This is the decription for this offer';
      model1.activated = '100';
      model1.redeemed = '100';
      activeNewUserOfferList.add(model1);
      activeNewUserOfferList.add(model1);

      OfferDataModel model2 = OfferDataModel();
      model2.title = 'Buy 1 Get 1 Free Inactive';
      model2.description = 'This is the decription for this offer';
      model2.activated = '50';
      model2.redeemed = '50';
      inactiveNewUserOfferList.add(model2);

      OfferDataModel model3 = OfferDataModel();
      model3.title = 'Discount of Rs 100';
      model3.description = 'This is the decription for this offer';
      model3.activated = '100';
      model3.redeemed = '100';
      activeCurrentUserOfferList.add(model3);

      OfferDataModel model4 = OfferDataModel();
      model4.title = 'Discount of Rs 100 Inactive';
      model4.description = 'This is the decription for this offer';
      model4.activated = '32';
      model4.redeemed = '20';
      inactiveCurrentUserOfferList.add(model4);

      _selectedOfferType = 'Activated';
      newUserOfferInputList.clear();
      for (var data in activeNewUserOfferList) {
        newUserOfferInputList.add(data);
      }
      currentUserOfferInputList.clear();
      for (var data in activeCurrentUserOfferList) {
        currentUserOfferInputList.add(data);
      }
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
            "Offers List",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icon/addWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateOffer()));
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xfffff4f4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  height: sm.scaledHeight(35),
                  child: ListView.builder(
                      itemCount: newUserOfferInputList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                  newUserOfferInputList[index].title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: AutoSizeText(
                                  newUserOfferInputList[index].description,
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
                                      "Activated : ${newUserOfferInputList[index].activated}",
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
                                      "Redeemed : ${newUserOfferInputList[index].redeemed}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      })),
              Text("New User Offers",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Container(
                  height: sm.scaledHeight( 35),
                  child: ListView.builder(
                      itemCount: currentUserOfferInputList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                  currentUserOfferInputList[index].title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: AutoSizeText(
                                  currentUserOfferInputList[index].description,
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
                                      "Activated : ${currentUserOfferInputList[index].activated}",
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
                                      "Redeemed : ${currentUserOfferInputList[index].redeemed}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      })),
            ],
          ),
        ));
  }
}
