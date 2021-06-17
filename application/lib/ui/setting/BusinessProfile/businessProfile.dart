import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/showPopup.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/component/workingDateTime.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class BusinessProfile extends StatelessWidget {
  bool isFirst;
  BusinessProfile({this.isFirst});
  // BusinessProfileProvider v;
  bool _autovalidate = false;
  bool abc = true;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    return Consumer<BusinessProfileProvider>(builder: (context, data, child) {
      if (isFirst) {
        data.getProfileData(context);
        //   v.localAuth();
        isFirst = false;
      }
      return WillPopScope(
        onWillPop: (){popMethod(data,context);},
        child: RefreshIndicator(
          onRefresh: () async {
            data.getProfileData(context);
          },
          child: Scaffold(
            key: RIKeys.josKeys25,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    print("WillpopCalled");
                    data.clear();
                    data.getProfileData(context);
                    Navigator.pop(context);
                    data.needSave(false);
                  }),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: data.loading
                ? Center(child: CircularProgressIndicator())
                : ListView(controller: data.listviewController, children: [
                    Text("Business Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontFamily: 'Gilroy-Bold',
                            letterSpacing: .2)),
                    Container(
                      margin: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 32.0),
                      child: Stack(children: [
                        Card(
                          margin: EdgeInsets.only(top: sm.h(10)),
                          child: Builder(
                            builder: (context) => Form(
                                key: RIKeys.josKeys24,
                                autovalidate: _autovalidate,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    SizedBox(height: sm.h(4)),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: sm.h(5), bottom: sm.h(2)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: (data
                                                  .controller[0].text.isEmpty)
                                              ? Container(
                                                  height: sm.h(20),
                                                  width: sm.w(50),
                                                  child: Image.asset(
                                                      'assets/icon/upload.png',
                                                      fit: BoxFit.fill))
                                              : CachedNetworkImage(
                                                  height: sm.h(24),
                                                  width: sm.w(84),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  imageUrl: data?.controller[0]
                                                          ?.text ??
                                                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngitem.com%2Fmiddle%2FhhmRJo_profile-icon-png-image-free-download-searchpng-employee%2F&psig=AOvVaw1JN_EBIRV8qqhAz589M0kw&ust=1613456728598000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCIjgwvKg6-4CFQAAAAAdAAAAABAD",
                                                  fit: BoxFit.fill),
                                        )),
                                    Container(
                                      width: sm.w(40),
                                      margin: EdgeInsets.only(bottom: 12.0),
                                      child: RoundedButton(
                                          clicker: () {
                                            data.getImage(ImgSource.Gallery);
                                          },
                                          clr: Colors.red,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Gilroy-Bold",
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1),
                                          title: data.addOrChangePhoto),
                                    ),
                                    for (int i = 1;
                                        i < data.titleList.length;
                                        i++)
                                      txtfieldboundry(
                                        controller: data.controller[i],
                                        title: data.titleList[i],
                                        security: false,
                                        isEnabled: i == 2 ? false : true,
                                        myOnChanged: (d) => data.needSave(true),
                                        valid: data.validateList[i],
                                        maxlen: i == 3 ? 12 : 50,
                                        focusNode: data.focusnode[i],
                                        keyboardSet: data.inputType[i],
                                        hint: "Enter ${data.titleList[i]}",
                                      ),
                                    // BusinessHours(),

                                    Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: DropdownSearch<String>(
                                            validator: (_v) => _v == ""
                                                ? 'required field'
                                                : null,
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            mode: Mode.MENU,
                                            showSelectedItem: true,
                                            selectedItem: data.text ?? '',
                                            items: [
                                              "Select Hours",
                                              "Always Open"
                                            ],
                                            label: "Working Hours",
                                            hint: "Please Select",
                                            showSearchBox: false,
                                            maxHeight: 110,
                                            onChanged: (value) {
                                              data.setText(
                                                  value != null ? value : "");
                                              data.getData();
                                              data.needSave(true);
                                            })),

                                    Visibility(
                                      visible: data.text == "Select Hours",
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Business Hours",
                                                      style: TextStyle(
                                                          color: myGrey)),
                                                  Visibility(
                                                    visible: false,
                                                    child: InkWell(
                                                      onTap: () {
                                                        data.getData();
                                                      },
                                                      child: Text(
                                                          "Refresh slot \u27F3",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      data.setMod(false);
                                                      showPopup(
                                                              ctx: context,
                                                              widget:
                                                                  WorkingDateTime(),
                                                              callback: () => data
                                                                  .popupClosed(),
                                                              sm: sm,
                                                              sizesLeft: 3,
                                                              sizesRight: 3,
                                                              sizesTop: 24,
                                                              sizesBottom: 44)
                                                          .show();
                                                    },
                                                    child: Text("+ Add",
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              // Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: sm.w(1)),
                                                // width: sm.w(60),
                                                height: sm.w(14),
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    for (int i = 0;
                                                        i <
                                                            data.selecteddayList
                                                                .length;
                                                        i++)
                                                      InkWell(
                                                        onTap: () {
                                                          data.setMod(true);
                                                          if (((data
                                                                  .selecteddayList
                                                                  .keys
                                                                  .toList())[i])
                                                              .contains('-')) {
                                                            print(
                                                                "range is called");
                                                            int _a = data
                                                                .daylist
                                                                .indexOf((((data
                                                                        .selecteddayList
                                                                        .keys
                                                                        .toList())[i])
                                                                    .split('-')[0]
                                                                    .trim()));

                                                            int _b = data
                                                                .daylist
                                                                .indexOf((((data
                                                                        .selecteddayList
                                                                        .keys
                                                                        .toList())[i])
                                                                    .split('-')[1]
                                                                    .trim()));
                                                            print("$_a ab ");
                                                            for (int _i = _a;
                                                                _i <= _b;
                                                                _i++) {
                                                              data.renge
                                                                  .add(_i);
                                                              data.selectDay(
                                                                  _i);
                                                            }
                                                          } else {
                                                            print(
                                                                "single is called");

                                                            data.renge.add(data
                                                                .daylist
                                                                .indexOf(data
                                                                    .selecteddayList
                                                                    .keys
                                                                    .toList()[i]));
                                                            data.selectDay(data
                                                                .daylist
                                                                .indexOf(data
                                                                    .selecteddayList
                                                                    .keys
                                                                    .toList()[i]));
                                                          }
                                                          showPopup(
                                                                  ctx: context,
                                                                  widget:
                                                                      WorkingDateTime(),
                                                                  callback:
                                                                      () => data
                                                                          .popupClosed(),
                                                                  sm: sm,
                                                                  sizesLeft: 3,
                                                                  sizesRight: 3,
                                                                  sizesTop: 24,
                                                                  sizesBottom:
                                                                      44)
                                                              .show();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        data.selecteddayList.keys.toList()[
                                                                            i],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    SizedBox(
                                                                        height:
                                                                            2),
                                                                    Text(
                                                                        "${(data.selecteddayList[data.selecteddayList.keys.toList()[i]].split("-")[0]).substring(0, 5)}-${(data.selecteddayList[data.selecteddayList.keys.toList()[i]].split("-")[1]).substring(0, 5)}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w200)),
                                                                  ])
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              // ])
                                            ]),
                                      ),
                                    ),

//code ends here for hours

                                    InkWell(
                                      onTap: () {
                                        data.byAppointment =
                                            !data.byAppointment;
                                        data.needSave(true);
                                        data.notifyListeners();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 20),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("By Appointment Only",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Gilroy-Bold',
                                                      color: Colors.grey)),
                                              Icon(
                                                data.byAppointment == false
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color:
                                                    data.byAppointment == false
                                                        ? Colors.red
                                                        : Colors.grey,
                                              )
                                            ]),
                                      ),
                                    ),
                                    SizedBox(height: sm.h(2)),
                                    Row(
                                      children: [
                                        Text('\t\t\tWhere are you located?',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Gilroy-Medium',
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: myGrey, width: 1)),
                                      height: 250,
                                      child: data.getPosition() != null
                                          ? MyGoogleMap(
                                              // controller: data.gMapcontroller
                                              )
                                          : Container(),
                                    ),
                                    for (int i = 0; i < data.addressLength; i++)
                                      txtfieldPostAction(
                                          controller: data.controller[i + 6],
                                          hint: "Enter Address ${i + 1}",
                                          title: "Address ${i + 1}",
                                          maxLines: 1,
                                          valid: i == 0,
                                          sufixColor: myGrey,
                                          sufixTxt: '',
                                          security: false,
                                          myOnChanged: (_) {
                                            data.needSave(true);
                                          },
                                          sufixClick: () {
                                            if (data.addressLength < 3)
                                              data.addressLength =
                                                  data.addressLength + 1;
                                          }),
                                    txtfieldboundry(
                                        controller: data.controller[9],
                                        title: "Pincode",
                                        security: false,
                                        valid: true,
                                        maxlen: 6,
                                        isEnabled: true,
                                        error: data.error[9],
                                        keyboardSet: TextInputType.number,
                                        hint: "Enter Pincode",
                                        myOnChanged: (_val) {
                                          data.pinCaller(_val, true);
                                        }),
                                    txtfieldboundry(
                                        controller: data.controller[10],
                                        title: "Town/City",
                                        hint: "Please Select Town/City",
                                        security: false,
                                        valid: true,
                                        isEnabled: false,
                                        error: data.error[10]),
                                    txtfieldboundry(
                                        controller: data.controller[11],
                                        title: "State",
                                        hint: "Please Select State",
                                        security: false,
                                        valid: true,
                                        isEnabled: false,
                                        error: data.error[11]),
                                    txtfieldboundry(
                                      controller: data.controller[12],
                                      title: "Country",
                                      security: false,
                                      valid: false,
                                      isEnabled: false,
                                      myOnChanged: (_) {
                                        data.needSave(true);
                                      },
                                      hint: "Enter Country",
                                    ),
                                    txtfieldboundry(
                                      controller: data.controller[13],
                                      title: "Email",
                                      security: false,
                                      isEnabled: false,
                                      valid: true,
                                      myOnChanged: (_) {
                                        data.needSave(true);
                                      },
                                      hint: "Enter Email",
                                    ),
                                    txtfieldboundry(
                                      title: "Short Description",
                                      controller: data.controller[14],
                                      maxLines: 3,
                                      valid: true,
                                      security: false,
                                      myOnChanged: (_) => data.needSave(true),
                                      hint: "Enter Description",
                                    ),
                                    txtfieldPostAction(
                                        controller: data.controller[15],
                                        hint: "Enter Website ",
                                        title: "Website ",
                                        maxLines: 1,
                                        valid: false,
                                        myOnChanged: (_) {
                                          data.needSave(true);
                                        },
                                        sufixColor: myRed,
                                        security: false,
                                        sufixClick: () {
                                          data.webSiteLengthPlus(15);
                                        }),
                                  ]),
                                )),
                          ),
                        ),
                        Positioned(
                            top: sm.h(4),
                            left: sm.w(8),
                            right: sm.w(8),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sm.w(0), vertical: sm.h(4)),
                                child: Column(children: [
                                  Text(
                                    "Your Business ID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        fontFamily: 'Gilroy-Medium'),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    business_id,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 1.2,
                                        fontFamily: 'Gilroy-Medium'),
                                  )
                                ]),
                              ),
                            ))
                      ]),
                    ),
                    Visibility(
                      visible: data.getNeedSave(),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: sm.w(60),
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: RoundedButton(
                              clicker: () {
                                if (RIKeys.josKeys24.currentState.validate())
                                  data.prepareWebService();
                                else {
                                  _autovalidate = true;
                                  data.notifyListeners();
                                }
                              },
                              clr: Colors.red,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Gilroy-Bold",
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.5),
                              title: donetxt),
                        ),
                      ),
                    )
                  ]),
          ),
        ),
      );
    });
  }

  void popMethod(data,context) {
    if(data.getNeedSave()){
  showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                            '\t\t\t\t\tPlease save your changes or cancel for discard.',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Gilroy-Medium'),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TextButton(
                                                                  child: Text(
                                                                      "save",
                                                                      style: TextStyle(
                                                                          color:
                                                                              myRed,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Gilroy-Medium')),
                                                                  onPressed:
                                                                      () {
                                                                    
                                                                           if (RIKeys.josKeys24.currentState.validate())
                                  data.prepareWebService();
                                else {
                                  _autovalidate = true;
                                  data.notifyListeners();
                                }Navigator.pop(
                                                                        context);Navigator.pop(
                                                                        context);
                                                                   
                                                                  }),
                                                              InkWell(
                                                                child: Text(
                                                                  "Discard",
                                                                  style: TextStyle(
                                                                      color:
                                                                          myRed,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Gilroy-Medium'),
                                                                ),
                                                                onTap: () {
Navigator.pop(
                                                                        context);
                                                                     
          Navigator.pop(context);
          data.clear();
          data.getProfileData(context);
          data.needSave(false);
                                                                }
                                                                    
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            
    }else{
      Navigator.pop(
                                                                        context);
    }
   
  }
}
