import 'package:Favorito/model/dashModel.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/network/webservices.dart';

class dashboardProvider extends ChangeNotifier {
  DashModel dashData = DashModel();
  Future<DashModel> calldashBoard(context) async {
    // await WebService.funGetDashBoard(context).then((value) {
    //   dashData = value;
    // notifyListeners();
    // dashData.businessId = value.busi nessId;
    // dashData.businessName = value.businessName;
    // dashData.businessStatus = value.businessStatus;
    // dashData.photo = value.photo;
    // dashData.isProfileCompleted = value.isProfileCompleted.toString();
    // dashData.isInformationCompleted = value.isInformationCompleted.toString();
    // dashData.isPhoneVerified = value.isPhoneVerified.toString();
    // dashData.isEmailVerified = value.isEmailVerified.toString();
    // dashData.isVerified = value.isVerified.toString();
    // dashData.checkIns = value.checkIns.toString();
    // dashData.ratings = value.ratings.toString();
    // dashDatacatalogoues = value.catalogoues.toString();
    // orders = value.orders.toString();
    // freeCredit = value.freeCredit.toString();
    // paidCredit = value.paidCredit.toString();
    // });
  }
}
