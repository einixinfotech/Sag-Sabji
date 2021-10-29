class PlaceOrderResponse {
  dynamic success;
  dynamic error;
  late Response response;

  PlaceOrderResponse(
      {required this.success, required this.error, required this.response});

  PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
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
  dynamic total;
  dynamic dlcharge;
  dynamic net;
  dynamic orderid;
  dynamic sms;
  dynamic razororderid;
  dynamic rAZORPAYAPIKEY;

  Response(
      {this.total,
      this.dlcharge,
      this.net,
      this.orderid,
      this.sms,
      this.razororderid,
      this.rAZORPAYAPIKEY});

  Response.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    dlcharge = json['dlcharge'];
    net = json['net'];
    orderid = json['orderid'];
    sms = json['sms'];
    razororderid = json['razororderid'];
    rAZORPAYAPIKEY = json['RAZORPAY_API_KEY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['dlcharge'] = this.dlcharge;
    data['net'] = this.net;
    data['orderid'] = this.orderid;
    data['sms'] = this.sms;
    data['razororderid'] = this.razororderid;
    data['RAZORPAY_API_KEY'] = this.rAZORPAYAPIKEY;
    return data;
  }
}
