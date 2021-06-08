// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:favorito_user/model/Chat/UserModel.dart';
// import 'package:favorito_user/ui/chat/ChatProvider.dart';
// import 'package:favorito_user/ui/chat/example.dart';
// import 'package:favorito_user/ui/chat/exp.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:provider/provider.dart';
// import '../../utils/Extentions.dart';

// class UserResult extends StatelessWidget {
//   final UserData eachUser;
//   UserResult({@required this.eachUser});
//   ChatProvider vaTrue;
//   bool isFirst = true;
//   @override
//   Widget build(BuildContext context) {
//     if (isFirst) {
//       vaTrue = Provider.of<ChatProvider>(context, listen: true);
//     }
//     return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         child: Card(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(12.0))),
//           child: Column(children: [
//             GestureDetector(
//                 onTap: () => sendUserToChatPage(context),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.black,
//                     backgroundImage:
//                         CachedNetworkImageProvider(eachUser?.photo),
//                   ),
//                   title: Text(
//                     (eachUser.name ?? '...').capitalize(),
//                     style: Theme.of(context).textTheme.headline6.copyWith(),
//                     textScaleFactor: .88,
//                   ),
//                   subtitle: Text(eachUser.shortDescription,
//                       style: Theme.of(context).textTheme.headline6.copyWith(
//                           fontWeight: FontWeight.w400, letterSpacing: .3),
//                       textScaleFactor: .6),
//                   trailing: Container(
//                     padding: EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle, color: Colors.red),
//                     child: Text('${eachUser?.unseenCount}',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline3
//                             .copyWith(fontSize: 10, color: Colors.white),
//                         textAlign: TextAlign.center),
//                   ),
//                 ))
//           ]),
//         ));
//   }

//   sendUserToChatPage(BuildContext context) {
//     vaTrue.setUserInfo(eachUser);
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => Example()));
//     Navigator.of(context).pushNamed('/chat');
//   }
// }
