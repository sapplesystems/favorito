// import 'package:favorito_user/config/SizeManager.dart';
// import 'package:favorito_user/model/Chat/UserModel.dart';
// import 'package:favorito_user/ui/chat/ChatProvider.dart';
// import 'package:favorito_user/ui/chat/UserResult.dart';
// import 'package:favorito_user/ui/chat/exp.dart';
// import 'package:favorito_user/utils/MyColors.dart';
// import 'package:favorito_user/utils/RIKeys.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// import 'package:provider/provider.dart';
// // import '../chat/UserResult.dart';
// import '../../utils/MyString.dart';
// import '../../utils/Extentions.dart';

// class ChatHome extends StatelessWidget {
//   SizeManager sm;
//   ChatProvider vaTrue;
//   bool isFirst = true;

//   @override
//   Widget build(BuildContext context) {
//     if (isFirst) {
//       isFirst = false;
//       vaTrue = Provider.of<ChatProvider>(context, listen: true);
//       vaTrue.getUserList();
//       sm = SizeManager(context);
//     }
//     return SafeArea(
//       child: Scaffold(
//           key: RIKeys.josKeys26,
//           body: RefreshIndicator(
//             onRefresh: () async {
//               vaTrue.getUserList();
//             },
//             child: Column(children: [
//               Expanded(
//                   flex: 1,
//                   child: Text("Inbox",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline6
//                           .copyWith(fontWeight: FontWeight.w500),
//                       textScaleFactor: 1.4)),
//               Expanded(flex: 1, child: header()),
//               Expanded(
//                 flex: 12,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: vaTrue.getUserModel().length,
//                     itemBuilder: (context, index) {
//                       List<UserData> userDataList = vaTrue.getUserModel();
//                       return UserResult(eachUser: userDataList[index]);
//                     },
//                   ),
//                 ),
//               ),
//             ]),
//           )),
//     );
//   }

//   newHistory(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
//       child: Text(title,
//           style: TextStyle(
//               fontSize: 14.0,
//               color:
//                   // vaFalse.getSelectedTab() == title ? myRed :
//                   myGrey)),
//     );
//   }

//   header() => Container(
//         // width: sm.w(100),
//         // margin: EdgeInsets.only(top: 16),
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: sm.w(60),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12.0))),
//             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               InkWell(
//                 onTap: () {},
//                 child: newHistory(message.toString().capitalize()),
//               ),
//               InkWell(
//                 onTap: () {},
//                 child: newHistory(notification.toString().capitalize()),
//               ),
//             ]),
//           ),
//         ),
//       );
// }
