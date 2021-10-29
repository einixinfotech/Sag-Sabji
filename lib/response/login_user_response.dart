class LoginUserResponse {
  late bool success;
  late bool error;
  late String userid;
  late String mobile;
  late String walletBalance;
  late int ismember;
  late String email;
  late String status;
  late String response;

  LoginUserResponse(
      {required this.success,
      required this.error,
      required this.userid,
      required this.mobile,
      required this.walletBalance,
      required this.ismember,
      required this.email,
      required this.status,
      required this.response});

  LoginUserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    userid = json['userid'];
    mobile = json['mobile'];
    walletBalance = json['walletBalance'];
    ismember = json['ismember'];
    email = json['email'];
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['userid'] = this.userid;
    data['mobile'] = this.mobile;
    data['walletBalance'] = this.walletBalance;
    data['ismember'] = this.ismember;
    data['email'] = this.email;
    data['status'] = this.status;
    data['response'] = this.response;
    return data;
  }
}
