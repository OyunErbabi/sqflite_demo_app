class Product {
  final int? id;
  final String name;

  Product({this.id, required this.name});

  factory Product.fromMap(Map<String, dynamic> json) =>
      new Product(id: json['id'], name: json['name']);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
