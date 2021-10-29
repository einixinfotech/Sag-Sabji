class OrderDetailsResponse {
  late bool? success;
  late String? points;
  late int? total;
  late String? dlcharge;
  late String? status;
  late int? subtotal;
  late bool? error;
  late List<Response>? response;

  OrderDetailsResponse(
      { this.success,
      this.points,
      this.total,
      this.dlcharge,
      this.status,
      this.subtotal,
      this.error,
      this.response});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    points = json['points'];
    total = json['total'];
    dlcharge = json['dlcharge'];
    status = json['status'];
    subtotal = json['subtotal'];
    error = json['error'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['points'] = this.points;
    data['total'] = this.total;
    data['dlcharge'] = this.dlcharge;
    data['status'] = this.status;
    data['subtotal'] = this.subtotal;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  late String id;
  late String name;
  late int rate;
  late int wrate;
  late String ismember;
  late String quantity;
  late int totalrate;
  late int totalwrate;

  Response(
      {required this.id,
      required this.name,
      required this.rate,
      required this.wrate,
      required this.ismember,
      required this.quantity,
      required this.totalrate,
      required this.totalwrate});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    wrate = json['wrate'];
    ismember = json['ismember'];
    quantity = json['quantity'];
    totalrate = json['totalrate'];
    totalwrate = json['totalwrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['wrate'] = this.wrate;
    data['ismember'] = this.ismember;
    data['quantity'] = this.quantity;
    data['totalrate'] = this.totalrate;
    data['totalwrate'] = this.totalwrate;
    return data;
  }
}
