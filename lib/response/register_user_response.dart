class RegisterUserResponse {
  late bool success;
  late bool error;
  late String response;

  RegisterUserResponse(
      {required this.success, required this.error, required this.response});

  RegisterUserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['response'] = this.response;
    return data;
  }
}
