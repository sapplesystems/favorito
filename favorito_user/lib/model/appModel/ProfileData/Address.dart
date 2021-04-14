class Address {
  int addressId;
  String city;
  String state;
  int pincode;
  String country;
  String landmark;
  String address;
  int defaultAddress;

  Address(
      {this.addressId,
      this.city,
      this.state,
      this.pincode,
      this.country,
      this.landmark,
      this.address,
      this.defaultAddress});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    country = json['country'];
    landmark = json['landmark'];
    address = json['address'];
    defaultAddress = json['default_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['landmark'] = this.landmark;
    data['address'] = this.address;
    data['default_address'] = this.defaultAddress;
    return data;
  }
}
