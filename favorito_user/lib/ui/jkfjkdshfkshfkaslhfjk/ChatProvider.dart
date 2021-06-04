import 'dart:async';
import 'dart:io';
import 'package:favorito_user/component/circularProgress.dart';
import 'package:favorito_user/model/Chat/ChatModel.dart';
import 'package:favorito_user/model/Chat/ChatModelData.dart';
import 'package:favorito_user/model/Chat/UserModel.dart';
import 'package:image_picker/image_picker.dart';

import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ChatProvider extends BaseProvider {
  List<UserData> userDataList = [];
  UserData _userInfo;
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker = false;
  bool isLoading = false;
  File imageFile;
  String imageUrl;
  String roomId = '';
  List<ChatModelData> chatModelData = [];
  void getUserList() async {
    await APIManager.getChatList(RIKeys.josKeys26).then((value) {
      userDataList.clear();
      for (var va in value.data) {
        print("ffff${va.toString()}");
        userDataList.add(va);
      }
      notifyListeners();
    });
  }

  getChathistory() {
    chatModelData.clear();
    Timer.periodic(Duration(seconds: 10), (_) {
      var va = {'room_id': '1', 'current_no_msg': chatModelData.length};
      print("121c:${va.toString()}");
      APIManager.getChat(va, RIKeys.josKeys26).then((value) {
        if (value.data.isNotEmpty) {
          print("121e:${value.data.length}");
          chatModelData.addAll(value.data);
          notifyListeners();
        }
        print("121a:${chatModelData.length}");
      });
    });
  }

  List<UserData> getUserModel() {
    return userDataList;
  }

  UserData getUserInfo() => _userInfo;
  setUserInfo(UserData _val) {
    _userInfo = _val;
    notifyListeners();
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      //hide stickers whenever keypad apear
      isDisplaySticker = false;
      notifyListeners();
    }
  }

  getChatModelData() => chatModelData;

  readLocal() async {
    focusNode.addListener(onFocusChange);
    // preferences = await SharedPreferences.getInstance();
    // id = preferences.getString("id") ?? "";
    // if (roomId == widget.userInfo.roomId) {
    //   roomId = '$id-${widget.userInfo.roomId}';
    // } else {
    //   roomId = '${widget.userInfo.roomId}-$id';
    // }
    // Firestore.instance
    //     .collection('user')
    //     .document(id)
    //     .updateData({'chattingWith': widget.userInfo.roomId});

    // notifyListeners();
  }

  Future<bool> onBackPress(context) {
    if (isDisplaySticker) {
      isDisplaySticker = false;
    } else {
      Navigator.pop(context);
    }
    chatModelData.clear();
    return Future.value(false);
  }

  createLoading() =>
      Positioned(child: isLoading ? circularProgress() : Container());

  void getStickers() {
    focusNode.unfocus();
    isDisplaySticker = !isDisplaySticker;
    notifyListeners();
  }

  getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = false;
    }
    // uploadImageFile();
  }
}
