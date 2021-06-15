// class RestrictionData {
//   String startDate;
//   String restrictionDate;

//   RestrictionData({this.restrictionId, this.restrictionDate});

//   RestrictionData.fromJson(Map<String, dynamic> json) {
//     restrictionId = json['restriction_id'];
//     restrictionDate = json['restriction_date'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['restriction_id'] = this.restrictionId;
//     data['restriction_date'] = this.restrictionDate;
//     return data;
//   }
// }
class RestrictionData {
  String startDate;
  String endDate;
  List<int> dateIds;

  RestrictionData({this.startDate, this.endDate, this.dateIds});

  RestrictionData.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    dateIds = json['dateIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['dateIds'] = this.dateIds;
    return data;
  }
}
