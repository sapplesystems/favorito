import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/Follow/FollowingData.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends BaseProvider {
  List<FollowingData> _followingDataList = [];
  List<FollowingData> _followingPersonList = [];
  List<FollowingData> _followingBusinessList = [];
  String followPageTitle = 'Followings';
  int _dataWill = 0;
  ProfileProvider() {
    getFollowing();
  }

  void dataWill(int _var) {
    _dataWill = _var;
    followPageTitle = _var == 1
        ? 'Followings'
        : _var == 2
            ? 'Followings Business'
            : _var == -3
                ? 'Followers'
                : '';

    notifyListeners();
  }

  void getFollowing() async {
    await APIManager.getFollowing({'relation_type': 3}).then((value) {
      _followingDataList.clear();
      _followingBusinessList.clear();
      _followingPersonList.clear();
      if (value.status == 'success') {
        _followingDataList.addAll(value.data);

        for (var _d in _followingDataList) {
          if (!onlyNumberRegex.hasMatch(_d.targetId))
            _followingBusinessList.add(_d);
          else
            _followingPersonList.add(_d);
        }
        notifyListeners();
      }
    });
  }

  List<FollowingData> getFollowingData() => _dataWill == 0
      ? _followingDataList
      : _dataWill == 1
          ? _followingPersonList
          : _followingBusinessList;

  abc() {
    // getFollowing();
  }
}
