import 'package:Favorito/model/TagList.dart';

class AdSpentModels {
  String status;
  String message;
  var totalSpent;
  var freeCredit;
  var paidCredit;
  List<Data> data;

  AdSpentModels(
      {this.status,
      this.message,
      this.totalSpent,
      this.freeCredit,
      this.paidCredit,
      this.data});

  AdSpentModels.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalSpent = json['total_spent'];
    freeCredit = json['free_credit'];
    paidCredit = json['paid_credit'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_spent'] = this.totalSpent;
    data['free_credit'] = this.freeCredit;
    data['paid_credit'] = this.paidCredit;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  List<TagList> keyword;
  String cpc;
  String totalBudget;
  String totalSpent;
  String impressions;
  int clicks;
  String status;

  Data(
      {this.id,
      this.name,
      this.keyword,
      this.cpc,
      this.totalBudget,
      this.totalSpent,
      this.impressions,
      this.clicks,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['keyword'] != null) {
      keyword = [];
      json['keyword'].forEach((v) {
        keyword.add(new TagList.fromJson(v));
      });
    }
    cpc = json['cpc'].toString();
    totalBudget = json['total_budget'].toString();
    totalSpent = json['total_spent'].toString();
    impressions = json['impressions'].toString();
    clicks = json['clicks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.keyword != null) {
      data['keyword'] = this.keyword.map((v) => v.toJson()).toList();
    }
    data['cpc'] = this.cpc;
    data['total_budget'] = this.totalBudget;
    data['total_spent'] = this.totalSpent;
    data['impressions'] = this.impressions;
    data['clicks'] = this.clicks;
    data['status'] = this.status;
    return data;
  }
}
