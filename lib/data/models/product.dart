class Product {
  String id;
  String name;
  int price;
  String? image;
  String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['price'] = this.price;
    map['image'] = this.image;
    map['description'] = this.description;
    return map;
  }
}
