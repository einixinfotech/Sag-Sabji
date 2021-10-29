class CartModel {
  dynamic _productId;
  dynamic _quantity;
  dynamic _rate;
  dynamic _productname;
  dynamic _productImage;

  dynamic get productname => _productname;
  dynamic get productImage => _productImage;

  set productImage(dynamic value) {
    _productImage = value;
  }

  set productname(dynamic value) {
    _productname = value;
  }

  CartModel(this._productId, this._quantity, this._rate, this._productname,this._productImage);

  dynamic get rate => _rate;

  set rate(dynamic value) {
    _rate = value;
  }

  dynamic get quantity => _quantity;

  set quantity(dynamic value) {
    _quantity = value;
  }

  dynamic get productId => _productId;

  set productId(dynamic value) {
    _productId = value;
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    productId = json['productid'];
    quantity = json['quantity'];
    rate = json['rate'];
    productname = json['productname'];
    productImage = json['productimage'];
  }

  Map<String, Object?> toJson() => {
        'productid': productId,
        'quantity': quantity,
        'rate': rate,
        'productname': productname,
        'productimage': productImage,
      };
}
