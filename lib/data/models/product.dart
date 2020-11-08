class Product {
  String id;
  String name;
  int price;
  String image;
  String description;

  Product({
    this.id,
    this.name,
    this.price,
    this.image,
    this.description,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    description = json['description'];
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
