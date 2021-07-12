import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorito_user/component/circularProgress.dart';
import 'package:favorito_user/ui/Chat/HomeScreen.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatLogin extends StatefulWidget {
  String mobileNo;
  bool imIn;

  ChatLogin({this.mobileNo, this.imIn});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<ChatLogin> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isOtpSend = false;
  bool isLoadingSet = false;
  SharedPreferences preferences;
  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerOtp = TextEditingController();
  FocusNode focusnode = FocusNode();
  String verificationId, smsCode;
  bool codeSent = false;

  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    // isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    widget.mobileNo = preferences.getString('phone');
    currentUserId = preferences.getString('id');
    _controllerOtp.text = '123456';
    // isLoggedIn = await googleSignIn.isSignedIn();
    if (currentUserId != null &&
        currentUserId != 'null' &&
        currentUserId.length > 4) {
      // Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    this.setState(() {
      focusnode.requestFocus();
      focusnode.canRequestFocus = false;
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: RIKeys.josKeys27,
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'favorito',
                style: Theme.of(context).textTheme.headline6.copyWith(),
                textScaleFactor: 1.8,
              ),
              GestureDetector(
                onTap: () => {
                  !isOtpSend
                      ? controlSignIn(RIKeys.josKeys27)
                      : AuthServices().signInWithOtp(_controllerOtp.text,
                          this.verificationId, RIKeys.josKeys27)
                },
                child: Center(
                  child: Column(children: [
                    SizedBox(height: 50),
                    Text(
                      // '+918178865073',
                      widget.mobileNo,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(letterSpacing: 2, color: myGrey),
                      textAlign: TextAlign.center,
                    ),
                    Visibility(
                      visible: isOtpSend,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: TextFormField(
                          controller: _controllerOtp,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(letterSpacing: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Text(
                        !isOtpSend ? 'verify' : 'login',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.2),
                      child: isLoading ? circularProgress() : Container(),
                    ),
                  ]),
                ),
              ),
            ]),
      ),
    );
  }

  Future<Null> controlSignIn(key) async {
    isLoadingSet = true;
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      print("verified is called");
      AuthServices().signIn(authResult, key, false);
    };

    final PhoneVerificationFailed verificationfield =
        (AuthException exception) {
      _controllerOtp.text = "";
      // snackBar(exception.message, RIKeys.josKeys21);
      isLoadingSet = (false);
      print("${exception.message}");
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResent]) {
      setState(() {
        this.verificationId = verId;
        isOtpSend = true;
        isLoadingSet = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout =
        (String verId) => this.verificationId = verId;

    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mobileNo}',
        timeout: const Duration(seconds: 10),
        verificationCompleted: verified,
        verificationFailed: verificationfield,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

class AuthServices {
  SharedPreferences preferences;

  AuthServices() {
    initCall();
  }

  initCall() async {
    preferences = await SharedPreferences.getInstance();
  }

  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            // return DashBoardPage();
            print("DashboardScreen");
          } else {
            // return LoginScreen();
            print("LoginScreen");
          }
        });
  }

//for signout
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds, key, bool mayIComeIn) async {
    FirebaseUser firebaseUser = (await FirebaseAuth.instance
            .signInWithCredential(authCreds)
            .onError((error, stackTrace) {
      print("otpError:${error.message}");
      Fluttertoast.showToast(msg: 'Invalid otp please try again.');
      return null;
    }))
        .user;
    var uid = firebaseUser.uid;
    preferences.setString('firebaseId', uid);

    print("uid:$uid");
    initFirebase(firebaseUser, key);
  }

  signInWithOtp(smsCode, verId, key) {
    print(smsCode);
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds, key, true);
  }

  void initFirebase(FirebaseUser firebaseUser, key) async {
    //Signin Success
    if (firebaseUser != null) {
      //check if already signedUp
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("user")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;
      //Save dota to firebase if new user
      if (documentSnapshots.length == 0) {
        // Map _map = {
        //   "nickname": preferences.getString('nickname') ?? "User",
        //   "photoUrl": preferences.getString('photoUrl') ?? 'null',
        //   "id": firebaseUser.uid,
        //   "aboutMe": "I am using favorito",
        //   "phone": firebaseUser.phoneNumber.toString(),
        //   "createAt": DateTime.now().microsecondsSinceEpoch.toString(),
        //   "chattingWith": 'null',
        // };
        // print("_map12:${_map.toString()}");
        Firestore.instance
            .collection("user")
            .document(firebaseUser.uid)
            .setData({});
        //Write data to Local

        await preferences.setString("id", firebaseUser.uid);
        await preferences.setString("phone", firebaseUser.phoneNumber);
        await preferences.setString("nickname", firebaseUser.displayName);
        await preferences.setString("photoUrl", firebaseUser.photoUrl);
      } else {
        //Write data to Local
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString(
            "nickname", documentSnapshots[0]["nickname"]);
        await preferences.setString("phone", documentSnapshots[0]["phone"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
        // await preferences.setString("id", documentSnapshots[0]["id"]);
      }
      Fluttertoast.showToast(msg: "Congratulations, Sign in Successful.");
      // this.setState(() {
      //   isLoading = false;
      // });

      Navigator.pop(key.currentContext);
      // Navigator.push(
      //     key.currentContext,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             HomeScreen()));
    }
    //SignIn not success

    else {
      Fluttertoast.showToast(msg: 'Try again , Sign in Failed');
    }
  }
}
