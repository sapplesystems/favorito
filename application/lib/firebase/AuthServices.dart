import 'package:Favorito/Functions/signIn.dart';
import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/ui/claim/ClaimProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices extends BaseProvider {
  SharedPreferences preferences;
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
  signIn(AuthCredential authCreds, GlobalKey<ScaffoldState> key) async {
    FirebaseUser firebaseUser = (await FirebaseAuth.instance
            .signInWithCredential(authCreds)
            .onError((error, stackTrace) {
      print("otpError:${error.message}");
      Provider.of<ClaimProvider>(key.currentContext, listen: false)
          .isLoadingSet(false);
      snackBar('Invalid otp please try again.', key);
      return null;
    }))
        .user;
    var uid = firebaseUser.uid;
    var phoneNumber = firebaseUser.phoneNumber;

    print("uid:$uid\nphoneNumber$phoneNumber");
    initFirebase(firebaseUser, key);
  }

  signInWithOtp(smsCode, verId, key) {
    print(smsCode);
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds, key);
  }
}
