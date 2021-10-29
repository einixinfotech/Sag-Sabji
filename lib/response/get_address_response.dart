class AddressResponse {
  late bool success;
  late bool error;
  late List<Response> response;

  AddressResponse(
      {required this.success, required this.error, required this.response});

  AddressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  late String addressid;
  late String userid;
  late String country;
  late String state;
  late String city;
  late String cityid;
  late String pincode;
  late String landmark;
  late String mobile;
  late String address;
  late String name;

  Response(
      {required this.addressid,
      required this.userid,
      required this.country,
      required this.state,
      required this.city,
      required this.cityid,
      required this.pincode,
      required this.landmark,
      required this.mobile,
      required this.address,
      required this.name});

  Response.fromJson(Map<String, dynamic> json) {
    addressid = json['addressid'];
    userid = json['userid'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    cityid = json['cityid'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    mobile = json['mobile'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressid'] = this.addressid;
    data['userid'] = this.userid;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['cityid'] = this.cityid;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
