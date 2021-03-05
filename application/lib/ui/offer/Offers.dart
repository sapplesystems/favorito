import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/offer/CreateOffer.dart';
import 'package:Favorito/ui/offer/ViewMore.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

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
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    initializeIntitialValues();
    super.initState();
    _selectedOfferType = 'Activated';
  }

  initializeIntitialValues() async {
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.funGetOfferData(context).then((value) {
        setState(() {
          activeNewUserOfferList.clear();
          inactiveNewUserOfferList.clear();
          activeCurrentUserOfferList.clear();
          inactiveCurrentUserOfferList.clear();
          // for (var temp in value.data) {
          //   if (temp.offerType == 'Current Offer') {
          //     if (temp.offerStatus == 'Activated') {
          //       activeCurrentUserOfferList.add(temp);
          //     } else {
          //       inactiveCurrentUserOfferList.add(temp);
          //     }
          //   } else if (temp.offerType == 'New User Offer') {
          //     if (temp.offerStatus == 'Activated') {
          //       activeNewUserOfferList.add(temp);
          //     } else {
          //       inactiveNewUserOfferList.add(temp);
          //     }
          //   }
          // }
          for (var temp in value.data) {
            if (temp.offerStatus == 'Activated') {
              if (temp.offerType == 'Current Offer') {
                activeCurrentUserOfferList.add(temp);
              } else if (temp.offerType == 'New User Offer') {
                activeNewUserOfferList.add(temp);
              }
            } else {
              if (temp.offerType == 'Current Offer') {
                inactiveCurrentUserOfferList.add(temp);
              } else if (temp.offerType == 'New User Offer') {
                inactiveNewUserOfferList.add(temp);
              }
            }
          }
          showData(_selectedOfferType);
          // newUserOfferInputList.clear();
          // for (var data in activeNewUserOfferList) {
          //   newUserOfferInputList.add(data);
          // }
          // currentUserOfferInputList.clear();
          // for (var data in activeCurrentUserOfferList) {
          //   currentUserOfferInputList.add(data);
          // }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    controller.text = _selectedOfferType;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop()),
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Offers List",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Gilroy-Bold',
                    fontSize: 26)),
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
                                builder: (context) => CreateOffer(
                                      offerData: null,
                                    )))
                        .whenComplete(() => initializeIntitialValues());
                  }),
              // IconButton(
              //   icon: SvgPicture.asset('assets/icon/addWaitlist.svg',
              //       alignment: Alignment.center),
              //   onPressed: () {
              //     Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => CreateOffer(
              //                       offerData: null,
              //                     )))
              //         .whenComplete(() => initializeIntitialValues());
              //   },
              // ),
            ]),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            shrinkWrap: true,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: sm.w(20), right: sm.w(20), top: 8.0, bottom: 16.0),
              //   child: InkWell(
              //     onTap: () {
              //       showPopup(
              //               sm: sm,
              //               ctx: context,
              //               callback: () {},
              //               widget: popupBody(sm),
              //               sizesLeft: 24,
              //               sizesTop: 40,
              //               sizesBottom: 40,
              //               sizesRight: 24)
              //           .show();
              //     },
              //     child: TextFormField(
              //       controller: controller,
              //       readOnly: true,
              //       enabled: false,
              //       decoration: InputDecoration(
              //         counterText: "",
              //         contentPadding: EdgeInsets.only(
              //             left: sm.w(12), right: sm.w(4), bottom: sm.w(6)),
              //         suffix:
              //             Icon(Icons.arrow_drop_down, size: 22, color: myGrey),
              //         suffixIconConstraints: BoxConstraints(),
              //         fillColor: Colors.transparent,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(16.0),
              //             borderSide: BorderSide(color: myGrey)),
              //       ),
              //     ),
              //   ),
              // ),

              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: sm.w(4), vertical: sm.w(4)),
                padding: EdgeInsets.symmetric(
                    horizontal: sm.w(24), vertical: sm.w(0)),
                child: DropdownSearch<String>(
                  validator: (v) => v == '' ? "required field" : null,
                  mode: Mode.MENU,
                  maxHeight: (offerTypeList.length ?? 0) * 52.0,
                  showSelectedItem: true,

                  selectedItem: _selectedOfferType,
                  items: offerTypeList != null ? offerTypeList : null,
                  // label: "Offer Type",

                  hint: "Please Select Offer Type",
                  showSearchBox: false,
                  onChanged: (value) {
                    showData(value);
                  },
                ),
              ),
              Text("New User Offers",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Column(children: [
                Container(
                  height: sm.h(34),
                  child: ListView.builder(
                      physics: new NeverScrollableScrollPhysics(),
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
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 16.0),
                                    // child: AutoSizeText(
                                    child: Text(
                                      newUserOfferInputList[index]
                                          .offerDescription,
                                      maxLines: 2,
                                      // minFontSize: 14,

                                      style: TextStyle(
                                          fontFamily: 'Gilroy-Medium',
                                          fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 16.0,
                                              bottom: 16.0),
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
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ])
                                ]),
                          ),
                        );
                      }),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMore(
                                    data: newUserOfferInputList, val: 'new')))
                        .whenComplete(() => initializeIntitialValues());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('View More',
                        style: TextStyle(
                            color: myRed, fontFamily: 'Gilroy-Medium')),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Current Offers",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              Column(
                children: [
                  Container(
                      height: sm.h(35),
                      child: ListView.builder(
                          physics: new NeverScrollableScrollPhysics(),
                          itemCount: currentUserOfferInputList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOffer(
                                              offerData:
                                                  currentUserOfferInputList[
                                                      index],
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
                                        currentUserOfferInputList[index]
                                            .offerTitle,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 16.0),
                                      // child: AutoSizeText(
                                      child: Text(
                                        currentUserOfferInputList[index]
                                            .offerDescription,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'Gilroy-Medium',
                                            fontSize: 14),
                                        // minFontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 16.0,
                                              bottom: 16.0),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewMore(
                                  data: currentUserOfferInputList,
                                  val: 'old')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text('View More',
                          style: TextStyle(
                              color: myRed, fontFamily: 'Gilroy-Medium')),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget popupBody(SizeManager sm) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
          onTap: () {
            setState(() {
              _selectedOfferType = offerTypeList[0];

              if (_selectedOfferType == offerTypeList[0].trim()) {
                newUserOfferInputList.clear();
                for (var data in activeNewUserOfferList) {
                  newUserOfferInputList.add(data);
                }
                currentUserOfferInputList.clear();
                for (var data in activeCurrentUserOfferList) {
                  currentUserOfferInputList.add(data);
                }
              }
            });
            Navigator.pop(context);
          },
          child: Text("    ${offerTypeList[0]}     ",
              textAlign: TextAlign.center)),
      Divider(
        height: sm.h(4),
      ),
      InkWell(
          onTap: () {
            setState(() {
              _selectedOfferType = offerTypeList[1];
              print(_selectedOfferType);

              newUserOfferInputList.clear();
              for (var data in inactiveNewUserOfferList) {
                newUserOfferInputList.add(data);
              }
              currentUserOfferInputList.clear();
              for (var data in inactiveCurrentUserOfferList) {
                currentUserOfferInputList.add(data);
              }
            });
            Navigator.pop(context);
          },
          child:
              Text("    ${offerTypeList[1]}     ", textAlign: TextAlign.center))
    ]);
  }

  void showData(value) {
    setState(() {
      _selectedOfferType = value;
      newUserOfferInputList.clear();
      currentUserOfferInputList.clear();
      newUserOfferInputList.clear();
      currentUserOfferInputList.clear();

      if (_selectedOfferType == offerTypeList[0].trim()) {
        for (var data in activeNewUserOfferList)
          newUserOfferInputList.add(data);

        for (var data in activeCurrentUserOfferList)
          currentUserOfferInputList.add(data);
      } else {
        for (var data in inactiveNewUserOfferList)
          newUserOfferInputList.add(data);

        for (var data in inactiveCurrentUserOfferList)
          currentUserOfferInputList.add(data);
      }
    });
  }
}
