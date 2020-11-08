import 'package:flutter/material.dart';

class CartItem {
  int id;
  String merchantId;
  String productId;
  String productName;
  int productPrice;
  int productQty;

  CartItem({
    @required this.merchantId,
    @required this.productId,
    @required this.productName,
    @required this.productPrice,
    @required this.productQty,
  });

  CartItem.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.merchantId = map['merchant_id'];
    this.productId = map['product_id'];
    this.productName = map['product_name'];
    this.productPrice = map['product_price'];
    this.productQty = map['product_qty'];
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
