class UserProfileResponse {
  late bool success;
  late bool error;
  late Response response;

  UserProfileResponse(
      {required this.success, required this.error, required this.response});

  UserProfileResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic userid;
  dynamic mobile;
  dynamic name;
  dynamic email;
  dynamic gender;
  dynamic ismember;
  dynamic validupto;
  dynamic refercode;
  dynamic appurl;
  dynamic refmsg;
  dynamic referData;
  dynamic points;

  Response(
      {required this.userid,
      required this.mobile,
      required this.name,
      required this.email,
      required this.gender,
      required this.ismember,
      required this.validupto,
      required this.refercode,
      required this.appurl,
      required this.refmsg,
      required this.referData,
      required this.points});

  Response.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    mobile = json['mobile'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    ismember = json['ismember'];
    validupto = json['validupto'];
    refercode = json['refercode'];
    appurl = json['appurl'];
    refmsg = json['refmsg'];
    referData = json['referData'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['ismember'] = this.ismember;
    data['validupto'] = this.validupto;
    data['refercode'] = this.refercode;
    data['appurl'] = this.appurl;
    data['refmsg'] = this.refmsg;
    data['referData'] = this.referData;
    data['points'] = this.points;
    return data;
  }
}
