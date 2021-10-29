class SendEnquiryResponse {
  dynamic success;
  dynamic error;
  dynamic response;

  SendEnquiryResponse({this.success, this.error, this.response});

  SendEnquiryResponse.fromJson(Map<String, dynamic> json) {
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
