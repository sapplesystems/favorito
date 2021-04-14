import 'package:favorito_user/model/appModel/Business/BaseResponse.dart';

class BaseListResponse<T> extends BaseResponse {
  var data;
  BaseListResponse({this.data});

  get getData => this.data;

  set setData(List list) {
    this.data = list;
  }

  BaseListResponse.fromJson(json) {
    if (json['data'] != null) {
      data = json['data'];
    }
  }
}
