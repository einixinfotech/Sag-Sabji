class TransactionHistoryResponse {
  late bool succsess;
  late bool error;
  late List<Response> response;

  TransactionHistoryResponse(
      {required this.succsess, required this.error, required this.response});

  TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    succsess = json['succsess'];
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
    data['succsess'] = this.succsess;
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
  late String amount;
  late String transactionType;
  late int closingBalance;
  dynamic remark;
  dynamic refId;
  late String type;
  late String createdAt;
  late String status;

  Response(
      {required this.id,
      required this.userid,
      required this.amount,
      required this.transactionType,
      required this.closingBalance,
      required this.remark,
      this.refId,
      required this.type,
      required this.createdAt,
      required this.status});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    amount = json['amount'];
    transactionType = json['transaction_type'];
    closingBalance = json['closing_balance'];
    remark = json['remark'];
    refId = json['ref_id'];
    type = json['type'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['amount'] = this.amount;
    data['transaction_type'] = this.transactionType;
    data['closing_balance'] = this.closingBalance;
    data['remark'] = this.remark;
    data['ref_id'] = this.refId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
