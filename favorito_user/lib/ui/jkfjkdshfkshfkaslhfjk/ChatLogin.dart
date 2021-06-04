// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:favorito_user/component/circularProgress.dart';
// import 'package:favorito_user/ui/chat/ChatHome.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:telegramchatapp/Widgets/ProgressWidget.dart';

// class ChatLogin extends StatefulWidget {
//   ChatLogin({Key key}) : super(key: key);
//   @override
//   ChatLoginState createState() => ChatLoginState();
// }

// class ChatLoginState extends State<ChatLogin> {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   SharedPreferences preferences;
//   bool isLoggedIn = false;
//   bool isLoading = false;
//   FirebaseUser currentUser;
//   TextEditingController _controller = TextEditingController();
//   TextEditingController _controllerOtp = TextEditingController();
//   FocusNode focusnode = FocusNode();
//   String verificationId, smsCode;
//   bool codeSent = false;
//   @override
//   void initState() {
//     super.initState();
//     isSignedIn();
//   }

//   void isSignedIn() async {
//     this.setState(() {
//       isLoggedIn = true;
//     });
//     preferences = await SharedPreferences.getInstance();
//     isLoggedIn = await googleSignIn.isSignedIn();
//     if (isLoggedIn) {
//       Navigator.pop(context);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ChatHome(
//                   // currentUserId: preferences.getString("id")
//                   )));
//     }
//     this.setState(() {
//       focusnode.requestFocus();
//       focusnode.canRequestFocus = false;
//       isLoggedIn = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [Colors.lightBlueAccent, Colors.purpleAccent])),
//         alignment: Alignment.center,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Buzzer',
//                 style: TextStyle(color: Colors.white, fontFamily: "Signatra"),
//                 textScaleFactor: 3,
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: TextFormField(
//                   keyboardType: TextInputType.number,
//                   controller: _controller,
//                   maxLength: 12,
//                   focusNode: focusnode,
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                       counterText: '',
//                       hintText: "Contact Number",
//                       prefixIcon: Icon(Icons.call, color: Colors.white),
//                       hintStyle: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               codeSent
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         controller: _controllerOtp,
//                         maxLength: 10,
//                         focusNode: focusnode,
//                         style: TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                             counterText: '',
//                             hintText: "Enter Otp",
//                             prefixIcon: Icon(Icons.call, color: Colors.white),
//                             hintStyle: TextStyle(color: Colors.white)),
//                       ),
//                     )
//                   : Container(),
//               InkWell(
//                 onTap: codeSent
//                     ? AuthServices()
//                         .signInWithOtp(_controllerOtp.text, verificationId)
//                     : controlMobileVerify,
//                 child: Container(
//                     margin: EdgeInsets.only(top: 30),
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                     decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white),
//                         borderRadius: BorderRadius.all(Radius.circular(30))),
//                     child: Text(
//                       codeSent ? 'Login' : 'Verify',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     )),
//               ),
//               Padding(
//                   padding: EdgeInsets.symmetric(vertical: 40),
//                   child: Divider(height: 1, color: Colors.white)),
//               GestureDetector(
//                 onTap: controlSignIn,
//                 child: Center(
//                   child: Column(children: [
//                     Container(
//                       width: 270,
//                       height: 65,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(
//                               'assets/images/google_signin_button.png'),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(1.2),
//                       child: isLoading ? circularProgress() : Container(),
//                     ),
//                   ]),
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }

//   Future<Null> controlSignIn() async {
//     preferences = await SharedPreferences.getInstance();
//     this.setState(() {
//       isLoading = true;
//     });
//     GoogleSignInAccount googleUser = await googleSignIn.signIn();
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     FirebaseUser firebaseUser =
//         (await firebaseAuth.signInWithCredential(credential)).user;
//     //Signin Success
//     if (firebaseUser != null) {
//       //check if already signedUp
//       final QuerySnapshot resultQuery = await Firestore.instance
//           .collection("user")
//           .where("id", isEqualTo: firebaseUser.uid)
//           .getDocuments();
//       final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;
//       //Save dota to firebase if new user
//       if (documentSnapshots.length == 0) {
//         Firestore.instance
//             .collection("user")
//             .document(firebaseUser.uid)
//             .setData({
//           "nickname": firebaseUser.displayName,
//           "photoUrl": firebaseUser.photoUrl,
//           "id": firebaseUser.uid,
//           "aboutMe": "I am using Buzzer",
//           "createAt": DateTime.now().microsecondsSinceEpoch.toString(),
//           "chattingWith": null,
//         });
//         //Write data to Local
//         currentUser = firebaseUser;
//         await preferences.setString("id", currentUser.uid);
//         await preferences.setString("nickname", currentUser.displayName);
//         await preferences.setString("photoUrl", currentUser.photoUrl);
//       } else {
//         //Write data to Local
//         currentUser = firebaseUser;
//         await preferences.setString("id", documentSnapshots[0]["id"]);
//         await preferences.setString(
//             "nickname", documentSnapshots[0]["nickname"]);
//         await preferences.setString(
//             "photoUrl", documentSnapshots[0]["photoUrl"]);
//         await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
//         // await preferences.setString("id", documentSnapshots[0]["id"]);
//       }
//       Fluttertoast.showToast(msg: "Congratulations, Sign in Successful.");
//       this.setState(() {
//         isLoading = false;
//       });

//       Navigator.pop(context);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => HomeScreen(
//                   // currentUserId: firebaseUser.uid
//                   )));
//     }
//     //SignIn not success
//     else {
//       Fluttertoast.showToast(msg: 'Try again , Sign in Failed');
//     }
//   }

//   Future<void> controlMobileVerify() async {
//     final PhoneVerificationCompleted verified = (AuthCredential authResult) {
//       AuthServices().signIn(authResult);
//     };
//     final PhoneVerificationFailed verificationfield =
//         (AuthException exception) {
//       print("${exception.message}");
//     };

//     final PhoneCodeSent smsSent = (String verId, [int forceResent]) {
//       this.verificationId = verId;
//       setState(() {
//         this.codeSent = true;
//       });
//     };

//     final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
//       this.verificationId = verId;
//     };

//     FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: "91${_controllerOtp.text.trim()}",
//         timeout: const Duration(seconds: 10),
//         verificationCompleted: verified,
//         verificationFailed: verificationfield,
//         codeSent: smsSent,
//         codeAutoRetrievalTimeout: autoTimeout);
//   }
// }

// class AuthServices {
//   handleAuth() {
//     return StreamBuilder(
//         stream: FirebaseAuth.instance.onAuthStateChanged,
//         builder: (BuildContext context, snapshot) {
//           if (snapshot.hasData) {
//             return DashBoardPage();
//           } else {
//             return LoginScreen();
//           }
//         });
//   }

// //for signout
//   signOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   //SignIn
//   signIn(AuthCredential authCreds) {
//     FirebaseAuth.instance.signInWithCredential(authCreds);
//   }

//   //signInWithOtp
//   signInWithOtp(smsCode, verId) {
//     print(smsCode);
//     AuthCredential authCreds = PhoneAuthProvider.getCredential(
//         verificationId: verId, smsCode: smsCode);
//     signIn(authCreds);
//   }
// }

// class DashBoardPage extends StatefulWidget {
//   @override
//   _DashBoardPageState createState() => _DashBoardPageState();
// }

// class _DashBoardPageState extends State<DashBoardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       child: RaisedButton(
//         child: Text("SignOut"),
//         onPressed: () {
//           AuthServices().signOut();
//         },
//       ),
//     ));
//   }
// }
