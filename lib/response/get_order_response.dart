class GetOrdersResponse {
  late bool success;
  late bool error;
  late List<Response> response;

  GetOrdersResponse(
      {required this.success, required this.error, required this.response});

  GetOrdersResponse.fromJson(Map<String, dynamic> json) {
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
  late String orderid;
  late String status;
  late int total;
  late String date;
  late String paymentstatus;

  Response(
      {required this.id,
      required this.orderid,
      required this.status,
      required this.total,
      required this.date,
      required this.paymentstatus});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderid = json['orderid'];
    status = json['status'];
    total = json['total'];
    date = json['date'];
    paymentstatus = json['paymentstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderid'] = this.orderid;
    data['status'] = this.status;
    data['total'] = this.total;
    data['date'] = this.date;
    data['paymentstatus'] = this.paymentstatus;
    return data;
  }
}
