import 'dart:async';
import 'package:Favorito/firebase/AuthServices.dart';
import 'package:Favorito/model/claimInfo.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimProvider extends ChangeNotifier {
  TextEditingController ctrlMobile;
  String otp = "";
  TextEditingController ctrlMail = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController();
  ClaimInfo claimInfo = ClaimInfo();
  TextEditingController otpController;
  bool isOtpSend = false;
  String currentUserId;
  SharedPreferences preferences;
  String verificationId;
  String otpVerify = "verify";
  String emailVerify = "verify";
  List<File> files = [];
  FilePickerResult result;
  bool needSubmit = false;
  bool isLoading = false;
  ClaimProvider() {
    ctrlMobile = TextEditingController();
    otpController = TextEditingController();
  }
  void initCall(context) async {
    preferences = await SharedPreferences.getInstance();
    currentUserId = preferences.getString("id");
      
    if (preferences.getString('isPhoneVerified')=='1') 
      otpVerify = 'verified';
    
    notifyListeners();
  }


  isLoadingSet(bool _val) {
    isLoading = _val;
    notifyListeners();
  }

  isOtpSendSet(bool _val) {
    isOtpSend = _val;
    // otpverify = 'verified';
    notifyListeners();
  }

  sendOtp(context) async {
    print("ffsffd");
    isLoadingSet(true);
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthServices().signIn(authResult, RIKeys.josKeys21);
    };

    final PhoneVerificationFailed verificationfield =
        (AuthException exception) {
      // otpController.text = "";
      BotToast.showText(text: exception.message);
      // snackBar(exception.message, RIKeys.josKeys21, myGreen);
      isLoadingSet(false);
      print("${exception.message}");
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResent]) {
      this.verificationId = verId;
      isOtpSend = true;
      notifyListeners();
      isLoadingSet(false);
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout =
        (String verId) => this.verificationId = verId;

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${ctrlMobile.text.trim()}",
        timeout: const Duration(seconds: 10),
        verificationCompleted: verified,
        verificationFailed: verificationfield,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  verifyOtp(v, context) async {
    print("complete is called");
    isLoadingSet(true);
    AuthServices().signInWithOtp(v, verificationId, RIKeys.josKeys21);
    
  }

  void funSendEmailVerifyLink(context) async {
    if (claimInfo?.result[0]?.isEmailVerified == 0) {
      if (await Provider.of<UtilProvider>(context, listen: false)
          .checkInternet()) {
        await WebService.funSendEmailVerifyLink(context).then((value) {
          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));
          if (value.status == 'success') {
            // emailverify = "";
            notifyListeners();
            getClaimData(context);
          }
        });
      }
    }
  }

  pickMyFile(context) async {
    result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) => File(path)).toList();
      setNeedSubmit(true);
    }
    if (result != null) {
      PlatformFile file = result?.files?.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    }
    double d = 0;
    for (int i = 0; i < result?.files?.length; i++) {
      d = d + double.parse(result?.files[i]?.size.toString());

      // if (d >
      //     double.parse(FlutterConfig.get(
      //         'image_max_length'))) {
      //   BotToast.showText(
      //       text: FlutterConfig.get(
      //           'image_max_length_message'));

      result.files.clear();
      notifyListeners();
      // }
    }
  }

  funClaimAdd(context) async {
    if (await Provider.of<UtilProvider>(context, listen: false)
        .checkInternet()) {
      await WebService.funClaimAdd(
              ctrlMobile.text, ctrlMail.text, files, context)
          .then((value) {
        setNeedSubmit(false);
        BotToast.showText(text: value.message, duration: Duration(seconds: 5));
        result.files.clear();
        Navigator.pop(context);
      });
    }
  }

  getClaimData(context) async {
    print("Claim is called");
    if (await Provider.of<UtilProvider>(context, listen: false)
        .checkInternet()) {
      await WebService.funClaimInfo(context).then((value) {
        if (value.status == 'success') {
          ctrlMail.text = value?.result[0]?.businessEmail;
          ctrlMobile.text = value?.result[0]?.businessPhone;
          claimInfo = value;
          preferences.setString('isPhoneVerified', '${claimInfo?.result[0]?.isPhoneVerified}') ;
          preferences.setString('isMailVerified', '${claimInfo?.result[0]?.isEmailVerified}') ;
    print("aaaaaa:${claimInfo?.result[0]?.isPhoneVerified}");
          otpVerify = claimInfo?.result[0]?.isPhoneVerified == 1?  "verified":"verify";
          emailVerify = claimInfo?.result[0]?.isEmailVerified == 1?   "verified":"verify";
        }
        if(otpVerify=="verified")isOtpSend=false;
      });
    }
        notifyListeners();
  }

  setNeedSubmit(_val) {
    needSubmit = _val;
    notifyListeners();
  }

  getNeedSubmit() => needSubmit;
}
