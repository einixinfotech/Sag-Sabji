class VerifyReferralCodeResponse {
  late bool success;
  late bool error;
  late String response;
  late String name;

  VerifyReferralCodeResponse(
      {required this.success,
      required this.error,
      required this.response,
      required this.name});

  VerifyReferralCodeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    response = json['response'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['response'] = this.response;
    data['name'] = this.name;
    return data;
  }
}
