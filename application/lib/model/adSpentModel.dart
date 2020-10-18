class adSpentModel {
  String status;
  String message;
  int totalSpent;
  int freeCredit;
  int paidCredit;
  List<String> data;

  adSpentModel(
      {this.status,
      this.message,
      this.totalSpent,
      this.freeCredit,
      this.paidCredit,
      this.data});

  adSpentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalSpent = json['total_spent'];
    freeCredit = json['free_credit'];
    paidCredit = json['paid_credit'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total_spent'] = this.totalSpent;
    data['free_credit'] = this.freeCredit;
    data['paid_credit'] = this.paidCredit;
    data['data'] = this.data;
    return data;
  }
}
