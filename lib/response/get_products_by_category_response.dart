class GetProductsByCategoryResponse {
  dynamic success = false;
  dynamic error = false;
  dynamic response = [];

  GetProductsByCategoryResponse({required this.success, required this.error, required this.response});

  GetProductsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    response = json['response'];
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
    data['response'] = this.response;
    /* if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Response {
  dynamic category;
  dynamic categoryid;
  dynamic productid;

  dynamic name;
  dynamic stock;
  dynamic capping;
  dynamic image;
  dynamic images;
  dynamic mrp;
  dynamic rate;
  dynamic wholesaleRate;
  List<Varient>? varient;
  bool hasInCart = false;

  Response(
      this.category,
      this.categoryid,
      this.productid,
      this.name,
      this.stock,
      this.capping,
      this.image,
      this.images,
      this.mrp,
      this.rate,
      this.wholesaleRate,
      this.varient);

  /* Response(
      {this.category,
      this.categoryid,
      this.productid,
      this.name,
      this.stock,
      this.capping,
      this.image,
      this.images,
      this.mrp,
      this.rate,
      this.wholesaleRate,
      this.varient});*/

  Response.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    categoryid = json['categoryid'];
    productid = json['productid'];
    name = json['name'];
    stock = json['stock'];
    capping = json['capping'];
    image = json['image'];

    mrp = json['mrp'];
    rate = json['rate'];
    wholesaleRate = json['wholesale_rate'];
    if (json['varient'] != null) {
      varient = <Varient>[];
      json['varient'].forEach((v) {
        varient!.add( Varient.fromJson(v));
      });
    }
    this.hasInCart=false;
    //hasInCart = json['hasInCart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['categoryid'] = this.categoryid;
    data['productid'] = this.productid;
    data['name'] = this.name;
    data['stock'] = this.stock;
    data['capping'] = this.capping;
    data['image'] = this.image;
    data['images'] = this.images;
    /* if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }*/
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['hasInCart'] = false;
    data['wholesale_rate'] = this.wholesaleRate;
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
    /*if (this.varient != null) {
      data['varient'] = this.varient.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Varient {
  String? category;
  String? categoryid;
  String? productid;
  String? name;
  String? stock;
  String? capping;
  String? headname;
  String? image;
  List<String>? images;
  String? mrp;
  String? rate;
  String? wholesaleRate;
  bool hasInCart = false;

  Varient(
      {this.category,
        this.categoryid,
        this.productid,
        this.name,
        this.stock,
        this.capping,
        this.headname,
        this.image,
        this.images,
        this.mrp,
        this.rate,
        this.hasInCart = false,
        this.wholesaleRate
      });

  Varient.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    categoryid = json['categoryid'];
    productid = json['productid'];
    name = json['name'];
    stock = json['stock'];
    capping = json['capping'];
    headname = json['headname'];
    image = json['image'];
    images = json['images'].cast<String>();
    mrp = json['mrp'];
    rate = json['rate'];
    wholesaleRate = json['wholesale_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['categoryid'] = this.categoryid;
    data['productid'] = this.productid;
    data['name'] = this.name;
    data['stock'] = this.stock;
    data['capping'] = this.capping;
    data['headname'] = this.headname;
    data['image'] = this.image;
    data['images'] = this.images;
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['wholesale_rate'] = this.wholesaleRate;
    return data;
  }
}
