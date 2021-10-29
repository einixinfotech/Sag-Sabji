class FirmDetailsResponse {
  late bool success;
  late bool error;
  late Response response;

  FirmDetailsResponse(
      {required this.success, required this.error, required this.response});

  FirmDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic terms;
  dynamic name;
  dynamic mobile;
  dynamic location;
  dynamic referData;
  dynamic popup;
  dynamic url;

  Response(
      {this.terms,
      this.name,
      this.mobile,
      this.location,
      this.referData,
      this.popup,
      this.url});

  Response.fromJson(Map<String, dynamic> json) {
    terms = json['terms'];
    name = json['name'];
    mobile = json['mobile'];
    location = json['location'];
    referData = json['referData'];
    popup = json['popup'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terms'] = this.terms;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['referData'] = this.referData;
    data['popup'] = this.popup;
    data['url'] = this.url;
    return data;
  }
}
