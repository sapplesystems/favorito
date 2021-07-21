import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/claim/ClaimProvider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  SharedPreferences preferences;
  AuthServices(){
      initCall();
  }
  initCall()async{
     preferences = await SharedPreferences.getInstance();
  }
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print("DashboardScreen");
          } else {
            print("LoginScreen");
          }
        });
  }

//for signout
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds, key) async {
    FirebaseMessaging firebaseMessaging= FirebaseMessaging();
    await firebaseMessaging.getToken().then((value) {
      print(value);
    });
    FirebaseUser firebaseUser = (await FirebaseAuth.instance
            .signInWithCredential(authCreds)
            .onError((error, stackTrace) {
      print("otpError:${error.message}");
      Fluttertoast.showToast(msg: 'Invalid otp please try again.');
      return null;
    })).user;
    var uid = firebaseUser.uid;
    preferences.setString('firebaseId',uid);
    if(uid!=null&&uid.length>4)
  await WebService.setGetFirebaseId({'api_type': 'set', 'firebase_id': uid}).then((value)=>
      WebService.funClaimVerifyOtp().then((value) {
         Provider.of<ClaimProvider>(key.currentContext,
                                                    listen: false)
                                                .getClaimData(key.currentContext);
      })
      
    );
  
print("uid:$uid");
initFirebase(firebaseUser, key);

  }

  signInWithOtp(smsCode, verId, key) {
    print(smsCode);
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds, key);
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
        Map _map = {
          "nickname": preferences.getString('nickname') ?? "User",
          "photoUrl": preferences.getString('photoUrl') ?? '',
          "id": firebaseUser.uid,
          "aboutMe": "I am using favorito",
          "phone": firebaseUser.phoneNumber,
          "createAt": DateTime.now().microsecondsSinceEpoch.toString(),
          "chattingWith": null,
        };
        print("_map12:${_map.toString()}");
        Firestore.instance.collection("user").document(firebaseUser.uid).setData({});
        //Write data to Local

        await preferences.setString("firebaseId", firebaseUser.uid);
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
      Fluttertoast.showToast(msg: "Congratulations.");
      // this.setState(() {
      //   isLoading = false;
      // });

      // Navigator.pop(context);
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
