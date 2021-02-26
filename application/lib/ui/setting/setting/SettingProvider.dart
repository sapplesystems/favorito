import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/PageViews/PageViews.dart';
import 'package:Favorito/ui/catalog/Catalogs.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/contactPerson/ContactPerson.dart';
import 'package:Favorito/ui/highlights/highlights.dart';
import 'package:Favorito/ui/jobs/JobList.dart';
import 'package:Favorito/ui/offer/Offers.dart';
import 'package:Favorito/ui/setting/BusinessProfile/businessProfile.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/waitlist/Waitlist.dart';
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider() {
    getProfileImage();
  }
  String photo = '';
  String shortdescription = '';
  List<String> title = [
    "Bussiness Profile",
    "Bussiness Information",
    "Claim Bussiness",
    "Owner Profile",
    "Create Offer",
    "Jobs",
    "Waitlist",
    "catalogs",
    "Create Highlights",
    "Page View"
  ];
  List<String> icon = [
    "shop",
    "circlenotyfy",
    "claim",
    "owner",
    "offer",
    "jobs",
    "waiting",
    "catlog",
    "highlights",
    "eye"
  ];
  List<Widget> pages = [
    BusinessProfile(),
    businessInfo(),
    BusinessClaim(),
    ContactPerson(),
    Offers(),
    JobList(),
    Waitlist(),
    Catalogs(),
    highlights(),
    PageViews(),
  ];
  bool settingHeight = true;
  bool settingTool = true;

  changeSettingHeight() {
    settingHeight = !settingHeight;
    notifyListeners();
  }

  changeSettingTool() {
    settingTool = !settingTool;
    notifyListeners();
  }

  getProfileImage() async {
    await WebService.funUserPhoto().then((value) {
      if (value.status == 'success') {
        this.photo = value.result[0].photo ?? '';
        this.shortdescription = value.result[0].shortDescription ?? '';
      }
      notifyListeners();
    });
  }
}
