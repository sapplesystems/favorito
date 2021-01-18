class BaseResponseModel {
  String status;
  String message;

  BaseResponseModel({
    this.status,
    this.message,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> datas) {
    return BaseResponseModel(
      status: datas["status"],
      message: datas["message"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
