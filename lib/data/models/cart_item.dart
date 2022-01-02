class CartItem {
  int? id;
  String merchantId;
  String productId;
  String productName;
  int productPrice;
  int productQty;

  CartItem({
    this.id,
    required this.merchantId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQty,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      merchantId: map['merchant_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      productPrice: map['product_price'],
      productQty: map['product_qty'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['merchant_id'] = this.merchantId;
    map['product_id'] = this.productId;
    map['product_name'] = this.productName;
    map['product_price'] = productPrice;
    map['product_qty'] = productQty;
    return map;
  }
}
