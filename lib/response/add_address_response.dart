class AddAddressResponse {
  late bool success;
  late bool error;
  late int addressid;
  late String response;

  AddAddressResponse(
      {required this.success,
      required this.error,
      required this.addressid,
      required this.response});

  AddAddressResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    addressid = json['addressid'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['addressid'] = this.addressid;
    data['response'] = this.response;
    return data;
  }
}
