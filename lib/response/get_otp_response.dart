class GetOTPResponse {
  late bool success;
  late bool error;
  late Response response;

  GetOTPResponse(
      {required this.success, required this.error, required this.response});

  GetOTPResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    response = (json['response'] != null
        ? new Response.fromJson(json['response'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  late int otp;
  late String msg;

  Response({required this.otp, required this.msg});

  Response.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['msg'] = this.msg;
    return data;
  }
}
