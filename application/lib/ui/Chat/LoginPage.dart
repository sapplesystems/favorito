import 'dart:async';
import 'package:Favorito/ui/Chat/ChatProvider.dart';
import 'package:Favorito/ui/Chat/HomeScreen.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatLogin extends StatefulWidget {
  ChatLogin({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<ChatLogin> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;
  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerOtp = TextEditingController();
  FocusNode focusnode = FocusNode();
  String verificationId, smsCode;
  bool codeSent = false;
  bool isFirst = true;
  String currentUserId;
  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    // isLoggedIn = await googleSignIn.isSignedIn();
    currentUserId = preferences.getString("id");
    // if (isLoggedIn) {
    if (currentUserId != null && currentUserId.length > 4) {
      // Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()));
    }
    print("currentUserId:$currentUserId");
    this.setState(() {
      focusnode.requestFocus();
      focusnode.canRequestFocus = false;
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isSignedIn();
      isFirst = false;
    }
    return Scaffold(
      key: RIKeys.josKeys20,
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
                // onTap: controlSignIn,
                onTap: () {
                  setState(() {
                    isFirst = true;
                  });
                },
                child: Center(
                  child: currentUserId != null
                      ? Transform.rotate(
                          angle: 300,
                          child: Icon(
                            Icons.arrow_circle_down,
                            size: 80,
                          ))
                      : Text(
                          'Please verify business contect number\n in claim section',
                          textAlign: TextAlign.center),
                ),
              ),
            ]),
      ),
    );
  }

  Future<Null> controlSignIn() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
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
        Firestore.instance
            .collection("user")
            .document(firebaseUser.uid)
            .setData({
          "nickname": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "aboutMe": "I am using Favorito",
          "email": firebaseUser.email,
          "createAt": DateTime.now().microsecondsSinceEpoch.toString(),
          "chattingWith": null,
        });
        //Write data to Local
        currentUser = firebaseUser;
        await preferences.setString("firebaseId", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        print("Email:${firebaseUser.email}");
        print("Email:${firebaseUser.uid}");
        Provider.of<ChatProvier>(context, listen: false)
            .sendEmailToserver(firebaseUser.email, RIKeys.josKeys20);
        Provider.of<ChatProvier>(context, listen: false)
            .sendFireBaseIdToServer(firebaseUser.uid, RIKeys.josKeys20);
      } else {
        //Write data to Local
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString(
            "nickname", documentSnapshots[0]["nickname"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
        // await preferences.setString("id", documentSnapshots[0]["id"]);
      }
      Fluttertoast.showToast(msg: "Congratulations, Sign in Successful.");
      this.setState(() {
        isLoading = false;
      });
    }
    //SignIn not success
    else {
      Fluttertoast.showToast(msg: 'Try again , Sign in Failed');
    }
  }
}
