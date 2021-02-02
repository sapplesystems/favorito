class BaseResponse<T> {
  String status;
  String message;
  T data;

  BaseResponse({this.status, this.message, this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json["status"],
      message: json["msg"] ?? "",
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
