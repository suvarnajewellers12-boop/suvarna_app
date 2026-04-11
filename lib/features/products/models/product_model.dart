class Product {
  final String id;
  final String name;
  final String weight;
  final String image;
  final String description;
  final String metalType;
  final String carats;

  Product({
    required this.id,
    required this.name,
    required this.weight,
    required this.image,
    required this.description,
    required this.metalType,
    required this.carats,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"].toString(),
      name: json["title"] ?? "",
      weight: json["weight"]?.toString() ?? "",
      image: json["image"] ?? "",
      description: json["description"] ?? "",
      metalType: json["metalType"] ?? "",
      carats: json["carats"] ?? "",
    );
  }
}