class CategoriesResponse {
  bool success = false;
  bool error = false;
  late List<Response> response = [];

  CategoriesResponse(
      {required this.success, required this.error, required this.response});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
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
    data['response'] = this.response.map((v) => v.toJson()).toList();
    return data;
  }
}

class Response {
  String categoryId = "";
  String name = "";
  String image = "";
  dynamic subcat;

  Response(
      {required this.categoryId,
      required this.name,
      required this.image,
      required this.subcat});

  Response.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    subcat = json['subcat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.subcat != null) {
      data['subcat'] = this.subcat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
