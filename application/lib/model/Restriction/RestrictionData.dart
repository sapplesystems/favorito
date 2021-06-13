class RestrictionData {
  int restrictionId;
  String restrictionDate;

  RestrictionData({this.restrictionId, this.restrictionDate});

  RestrictionData.fromJson(Map<String, dynamic> json) {
    restrictionId = json['restriction_id'];
    restrictionDate = json['restriction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restriction_id'] = this.restrictionId;
    data['restriction_date'] = this.restrictionDate;
    return data;
  }
}
