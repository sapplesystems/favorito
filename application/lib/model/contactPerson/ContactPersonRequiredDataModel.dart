class ContactPersonRequiredDataModel {
  String status;
  String message;
  List<String> userRole;
  Data data;

  ContactPersonRequiredDataModel(
      {this.status, this.message, this.userRole, this.data});

  ContactPersonRequiredDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userRole = (json['user_role'] as List<dynamic>)?.cast<String>();
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_role'] = this.userRole;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String businessId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String role;
  String bankAcHolderName;
  String accountNumber;
  String ifscCode;
  String upi;
  List<Branches> branches;

  Data(
      {this.id,
      this.businessId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.role,
      this.bankAcHolderName,
      this.accountNumber,
      this.ifscCode,
      this.upi,
      this.branches});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    bankAcHolderName = json['bank_ac_holder_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    upi = json['upi'];
    if (json['branches'] != null) {
      branches = new List<Branches>();
      json['branches'].forEach((v) {
        branches.add(new Branches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['bank_ac_holder_name'] = this.bankAcHolderName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['upi'] = this.upi;
    if (this.branches != null) {
      data['branches'] = this.branches.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toString() =>
      "{ id : $id , business_id : $businessId , firstName : $firstName , lastName : $lastName , email : $email , phone : $phone , phone : $phone , role : $role , bankAcHolderName : $bankAcHolderName , ifscCode : $ifscCode , upi : $upi}";
}

class Branches {
  int id;
  String branchAddress;
  String branchName;
  String branchPhoto;

  Branches({this.id, this.branchAddress, this.branchName});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchAddress = json['branch_address'];
    branchName = json['branch_name'];
    branchPhoto = json['branch_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_address'] = this.branchAddress;
    data['branch_name'] = this.branchName;
    data['branch_photo'] = this.branchPhoto;
    return data;
  }
}
