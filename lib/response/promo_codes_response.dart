class PromoCodesResponse {
  late bool success;
  late bool error;
  late List<Response> response;

  PromoCodesResponse(
      {required this.success, required this.error, required this.response});

  PromoCodesResponse.fromJson(Map<String, dynamic> json) {
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
  late String id;
  late String userid;
  late String code;
  late String billamount;
  late String discount;
  late String maxdiscount;
  late String type;
  late String startdate;
  late String enddate;
  late String msg;
  late String createdAt;
  late String status;
  late String image;

  Response(
      {required this.id,
      required this.userid,
      required this.code,
      required this.billamount,
      required this.discount,
      required this.maxdiscount,
      required this.type,
      required this.startdate,
      required this.enddate,
      required this.msg,
      required this.createdAt,
      required this.status,
      required this.image});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    code = json['code'];
    billamount = json['billamount'];
    discount = json['discount'];
    maxdiscount = json['maxdiscount'];
    type = json['type'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    msg = json['msg'];
    createdAt = json['created_at'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['code'] = this.code;
    data['billamount'] = this.billamount;
    data['discount'] = this.discount;
    data['maxdiscount'] = this.maxdiscount;
    data['type'] = this.type;
    data['startdate'] = this.startdate;
    data['enddate'] = this.enddate;
    data['msg'] = this.msg;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
