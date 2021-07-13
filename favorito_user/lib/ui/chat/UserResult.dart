import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorito_user/model/Chat/ChatUserList.dart';
import 'package:favorito_user/ui/Chat/ChattingPage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserResult extends StatelessWidget {
  final ChatUser eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(4),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(children: [
              GestureDetector(
                  onTap: () => sendUserToChatPage(context),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          CachedNetworkImageProvider(eachUser?.photo ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTd09TGDcJFx-t_B0HiUkc123nrs2MnSG4WWg&usqp=CAU"),
                    ),
                    title: Text(
                      eachUser.name??"",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      eachUser.shortDescription??'',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 14.0, fontWeight: FontWeight.w400),
                    ),
                  ))
            ]),
          ),
        ));
  }

  sendUserToChatPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chat(userInfo:eachUser)));
  }
}
