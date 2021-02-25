import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHours.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class BusinessProfile extends StatelessWidget {
  BusinessProfileProvider v;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    v = Provider.of<BusinessProfileProvider>(context, listen: true);
    v.setContext(context);
    if (v?.controller[1]?.text?.isEmpty) v.getProfileData(false);


    return RefreshIndicator(
      onRefresh: () async {
        v.getProfileData(true);
      },
      child: Consumer<BusinessProfileProvider>(builder: (context, data, child) {
        return WillPopScope(
          onWillPop: () {
            print("backpresed");
            v.needSave(false);
            Navigator.pop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                    v.needSave(false);
                  }),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            body: ListView(controller: v.listviewController, children: [
              Text("Business Profile",
                  textAlign: TextAlign.center, style: appBarStyle),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Stack(children: [
                  Card(
                    margin: EdgeInsets.only(top: sm.h(10)),
                    child: Builder(
                      builder: (context) => Form(
                          key: data.formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              SizedBox(height: sm.h(4)),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: sm.h(5), bottom: sm.h(2)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: (data.controller[0].text.isEmpty)
                                          ? Container(
                                              height: sm.h(20),
                                              width: sm.w(50),
                                              child: Image.asset(
                                                  'assets/icon/upload.png',
                                                  fit: BoxFit.fill))
                                          : Image.network(
                                              data?.controller[0]?.text ??
                                                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngitem.com%2Fmiddle%2FhhmRJo_profile-icon-png-image-free-download-searchpng-employee%2F&psig=AOvVaw1JN_EBIRV8qqhAz589M0kw&ust=1613456728598000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCIjgwvKg6-4CFQAAAAAdAAAAABAD",
                                              height: sm.h(20),
                                              width: sm.w(72),
                                              fit: BoxFit.fill,
                                            ))),
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
                              for (int i = 1; i < data.titleList.length; i++)
                                txtfieldboundry(
                                  controller: data.controller[i],
                                  title: data.titleList[i],
                                  security: false,
                                  myOnChanged: (d) => v.needSave(true),
                                  valid: data.validateList[i],
                                  maxlen: i == 3 ? 12 : 50,
                                  focusNode: data.focusnode[i],
                                  keyboardSet: data.inputType[i],
                                  hint: "Enter ${data.titleList[i]}",
                                ),
                              BusinessHours(dd1: data.dd1),
                              InkWell(
                                onTap: () =>
                                    data.byAppointment = !data.byAppointment,
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
                                              : Icons.check_box_outline_blank,
                                          color: data.byAppointment == false
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
                                //_controller[6] is allign for this
                                margin: EdgeInsets.all(8),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: myGrey, width: 1)),
                                height: 250,
                                child: data.getPosition() != null
                                    ? MyGoogleMap(
                                        controller: data.GMapcontroller)
                                    : Container(),
                              ),
                              for (int i = 0; i < data.addressLength; i++)
                                txtfieldPostAction(
                                    controller: data.controller[i + 6],
                                    hint: "Enter Address ${i + 1}",
                                    title: "Address ${i + 1}",
                                    maxLines: 1,
                                    valid: data.addressLength > 0,
                                    sufixColor: myGrey,
                                    sufixTxt: "Add Line",
                                    security: false,
                                    myOnChanged: (_) {
                                      v.needSave(true);
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
                                  error: v.error[9],
                                  keyboardSet: TextInputType.number,
                                  hint: "Enter Pincode",
                                  myOnChanged: (_val) {
                                    data.pinCaller(_val);
                                    v.needSave(true);
                                  }),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  key: data.ddCity,
                                  showSelectedItem: true,
                                  validator: (_v) {
                                    var va;
                                    if (_v == "") {
                                      va = 'required field';
                                    } else {
                                      va = null;
                                    }
                                    return va;
                                  },
                                  selectedItem: data.controller[10].text,
                                  items: data.cityList != null
                                      ? data.cityList
                                      : null,
                                  label: "Town/City",
                                  hint: "Please Select Town/City",
                                  showSearchBox: true,
                                  onChanged: (value) {
                                    data.controller[10].text = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: DropdownSearch<String>(
                                  validator: (_v) {
                                    var va;
                                    if (_v == "") {
                                      va = 'required field';
                                    } else {
                                      va = null;
                                    }
                                    return va;
                                  },
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  key: data.ddState,
                                  showSelectedItem: true,
                                  selectedItem: data.controller[11].text,
                                  items: data.stateList != null
                                      ? data.stateList
                                      : null,
                                  label: "State",
                                  hint: "Please Select State",
                                  showSearchBox: true,
                                  onChanged: (_value) {
                                    data.controller[11].text = _value;
                                    data.controller[12].text = "India";

                                    v.needSave(true);
                                  },
                                ),
                              ),
                              txtfieldboundry(
                                controller: data.controller[12],
                                title: "Country",
                                security: false,
                                valid: false,
                                isEnabled: false,
                                myOnChanged: (_) {
                                  v.needSave(true);
                                },
                                hint: "Enter Country",
                              ),
                              txtfieldboundry(
                                controller: data.controller[13],
                                title: "Email",
                                security: false,
                                valid: true,
                                myOnChanged: (_) {
                                  v.needSave(true);
                                },
                                hint: "Enter Email",
                              ),
                              txtfieldboundry(
                                title: "Short Description",
                                controller: data.controller[14],
                                maxLines: 3,
                                valid: true,
                                security: false,
                                myOnChanged: (_) {
                                  v.needSave(true);
                                },
                                hint: "Enter Description",
                              ),
                              for (int i = 0; i < data.webSiteLength; i++)
                                txtfieldPostAction(
                                    controller: data.controller[15 + i],
                                    hint: "Enter Website ",
                                    title: "Website ",
                                    maxLines: 1,
                                    valid: false,
                                    myOnChanged: (_) {
                                      v.needSave(true);
                                    },
                                    sufixColor: myRed,
                                    sufixTxt: "Add Line",
                                    security: false,
                                    sufixClick: () {
                                      data.webSiteLengthPlus();
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
                visible: v.getNeedSave(),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: sm.w(60),
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: RoundedButton(
                        clicker: () {
                          if (data.formKey.currentState.validate())
                            data.prepareWebService();
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
        );
      }),
    );
  }
}
