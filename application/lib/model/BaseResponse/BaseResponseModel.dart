class BaseResponseModel {
  String status;
  String message;
  // T data;

  BaseResponseModel({
    this.status,
    this.message,
    //  this.data
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> datas) {
    return BaseResponseModel(
      status: datas["status"],
      message: datas["message"],
      // data: key.isEmpty ? datas : datas[key]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
