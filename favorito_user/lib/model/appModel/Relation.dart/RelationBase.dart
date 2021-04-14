import 'package:favorito_user/model/appModel/Business/RelationModel.dart';

class RelationBase {
  String status;
  String message;
  List<Relation> data;

  RelationBase({this.status, this.message, this.data});

  RelationBase.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Relation>();
      json['data'].forEach((v) {
        data.add(new Relation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
