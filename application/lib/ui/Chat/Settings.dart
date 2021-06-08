// import 'dart:async';
// import 'dart:io';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class Settings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "Account Setting",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.lightBlue,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         child: SettingsScreen(),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatefulWidget {
//   @override
//   State createState() => SettingsScreenState();
// }

// class SettingsScreenState extends State<SettingsScreen> {
//   SharedPreferences preferences;
//   TextEditingController nickNameController;
//   TextEditingController aboutMeController;
//   String id = '';
//   String nickname = '';
//   String aboutMe = '';
//   String photoUrl = '';
//   File imageFileAvatar;
//   bool isLoading = false;
//   final FocusNode nickNameFocusNode = FocusNode();
//   final FocusNode aboutMeFocusNode = FocusNode();

//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   @override
//   void initState() {
//     super.initState();
//     readDataFromLocal();
//   }

//   Future getImage() async {
//     File newImageFile =
//         await ImagePicker.pickImage(source: ImageSource.gallery);
//     if (newImageFile != null) {
//       setState(() {
//         this.imageFileAvatar = newImageFile;
//         isLoading = true;
//       });
//     }
//     uploadImageToFireStoreAndStorage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//             child: Column(
//           children: [
//             Container(
//               child: Center(
//                 child: Stack(children: [
//                   (imageFileAvatar == null)
//                       ? (photoUrl != "")
//                           ? Material(
//                               //displays already existing -old image file
//                               child: CachedNetworkImage(
//                                   placeholder: (context, url) => Container(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2.0,
//                                           valueColor: AlwaysStoppedAnimation(
//                                               Colors.lightBlueAccent),
//                                         ),
//                                         width: 200,
//                                         height: 200,
//                                         padding: EdgeInsets.all(20),
//                                       ),
//                                   imageUrl: photoUrl,
//                                   width: 200,
//                                   height: 200,
//                                   fit: BoxFit.cover),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(125)),
//                               clipBehavior: Clip.hardEdge,
//                             )
//                           : Icon(Icons.account_circle,
//                               size: 90, color: Colors.grey)
//                       : Material(
//                           //display the new update image here
//                           child: Image.file(imageFileAvatar,
//                               width: 200, height: 200, fit: BoxFit.cover),
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(125.0)),
//                           clipBehavior: Clip.hardEdge,
//                         ),
//                   IconButton(
//                     icon: Icon(Icons.camera_alt,
//                         size: 100, color: Colors.white54.withOpacity(0.3)),
//                     onPressed: getImage,
//                     padding: EdgeInsets.all(0),
//                     color: Colors.transparent,
//                     highlightColor: Colors.grey,
//                     iconSize: 200.0,
//                   )
//                 ]),
//               ),
//               width: double.infinity,
//               margin: EdgeInsets.all(20),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(1),
//                   child: isLoading ? circularProgress() : Container(),
//                 ),
//                 Container(
//                   child: Text("Profile Name",
//                       style: Theme.of(context).textTheme.headline6.copyWith(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.lightBlueAccent,
//                           fontStyle: FontStyle.italic)),
//                 ),
//                 Container(
//                   margin:
//                       EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
//                   child: Theme(
//                     data: Theme.of(context)
//                         .copyWith(primaryColor: Colors.lightBlueAccent),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "hi this is hint text",
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .headline6
//                             .copyWith(color: Colors.grey),
//                       ),
//                       controller: nickNameController,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6
//                           .copyWith(fontSize: 18, color: Colors.black54),
//                       onChanged: (value) {
//                         nickname = value;
//                       },
//                       focusNode: nickNameFocusNode,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: Text("About Me",
//                       style: Theme.of(context).textTheme.headline6.copyWith(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.lightBlueAccent,
//                           fontStyle: FontStyle.italic)),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10),
//                   child: Theme(
//                     data: Theme.of(context)
//                         .copyWith(primaryColor: Colors.lightBlueAccent),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Bio...",
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .headline6
//                             .copyWith(color: Colors.grey),
//                       ),
//                       controller: aboutMeController,
//                       onChanged: (value) {
//                         aboutMe = value;
//                       },
//                       focusNode: aboutMeFocusNode,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6
//                           .copyWith(fontSize: 18, color: Colors.black54),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             //buttons for update
//             Container(
//               child: FlatButton(
//                 onPressed: updateDate,
//                 color: Colors.lightBlueAccent,
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.grey,
//                 textColor: Colors.white,
//                 padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                 child: Text(
//                   "Update",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               margin: EdgeInsets.only(top: 50, bottom: 1),
//             ),
//             Padding(
//               child: RaisedButton(
//                   color: Colors.red,
//                   child: Text(
//                     "Logout",
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                   onPressed: () => logoutUser()),
//               padding: EdgeInsets.only(left: 50, right: 50),
//             )
//           ],
//         ))
//       ],
//     );
//   }

//   void readDataFromLocal() async {
//     preferences = await SharedPreferences.getInstance();
//     id = preferences.getString("id");
//     nickname = preferences.getString("nickname");
//     aboutMe = preferences.getString("aboutMe");
//     photoUrl = preferences.getString("photoUrl");
//     nickNameController = TextEditingController(text: nickname);
//     aboutMeController = TextEditingController(text: aboutMe);
//     setState(() {});
//   }

//   Future<Null> logoutUser() async {
//     await FirebaseAuth.instance.signOut();
//     await googleSignIn.disconnect();
//     await googleSignIn.signOut();
//     setState(() {
//       isLoading = false;
//     });

//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => ChatLogin()),
//         (Route<dynamic> route) => false);
//   }

//   Future uploadImageToFireStoreAndStorage() async {
//     String mFileName = id;
//     StorageReference storageReference =
//         FirebaseStorage.instance.ref().child(mFileName);
//     StorageUploadTask storageUploadTask =
//         storageReference.putFile(imageFileAvatar);
//     StorageTaskSnapshot storageTaskSnapshot;
//     storageUploadTask.onComplete.then((value) {
//       if (value.error == null) {
//         storageTaskSnapshot = value;
//         storageTaskSnapshot.ref.getDownloadURL()?.then((newImageDownloadUrl) {
//           photoUrl = newImageDownloadUrl;
//           Firestore.instance.collection('user').document(id).updateData({
//             "photoUrl": newImageDownloadUrl,
//             "aboutMe": aboutMe,
//             "nickname": nickname
//           }).then((value) async {
//             await preferences.setString("photoUrl", photoUrl);
//             setState(() {
//               isLoading = false;
//             });

//             Fluttertoast.showToast(msg: 'Uploaded succesfully');
//           });
//         }, onError: (errorMsg) {
//           setState(() {
//             isLoading = false;
//           });

//           Fluttertoast.showToast(
//               msg: 'Error occure in getting Downloading Url.');
//         });
//       }
//     }, onError: (errorMsg) {
//       setState(() {
//         isLoading = false;
//       });

//       Fluttertoast.showToast(msg: errorMsg.toString());
//     });
//   }

//   void updateDate() async {
//     nickNameFocusNode.unfocus();
//     aboutMeFocusNode.unfocus();
//     setState(() {
//       isLoading = false;
//     });

//     print("nickname:${id.toString()}");
//     var _map = {"photoUrl": photoUrl, "aboutMe": aboutMe, "nickname": nickname};
//     CollectionReference v = Firestore.instance.collection("user");
//     v.document(id).updateData(_map).then((value) async {
//       await preferences.setString("photoUrl", photoUrl);
//       await preferences.setString("aboutMe", aboutMe);
//       await preferences.setString("nickname", nickname);
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'Uploaded succesfully');
//     });
//   }
// }
