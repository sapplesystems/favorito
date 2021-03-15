import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProfileProvider extends ChangeNotifier {
  List<String> menuTitleList = [
    "Edit profile",
    "Reviews",
    "Photos added with reviews",
    "Check-ins",
    "Favourites",
    "Refer fiend/place",
    'Saved Addresses',
    "Orders",
    "Friends",
    "Followers",
    "Following",
    "Following Business",
    "Find friend by name",
    "Liked posts",
    "Blocked users",
    "Terms of services",
    "Privacy policy",
    "Licenses",
    "Change login details",
    "Delete Acount",
    'Logout'
  ];
  List menuIconList = [
    'edit',
    'star',
    'camera',
    'check',
    'favorite',
    'refer',
    'location',
    'bucket',
    'friend',
    'follow',
    'following',
    'shirt',
    'find',
    'heart',
    'block',
    'term',
    'privacy',
    'license',
    'changePass',
    'delete',
    'logout2'
  ];
}
