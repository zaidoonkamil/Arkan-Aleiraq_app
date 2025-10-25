import 'dart:convert';

List<GetProducts> getProductsFromJson(String str) => List<GetProducts>.from(json.decode(str).map((x) => GetProducts.fromJson(x)));

String getProductsToJson(List<GetProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetProducts {
  int id;
  String title;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;

  GetProducts({
    required this.id,
    required this.title,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetProducts.fromJson(Map<String, dynamic> json) => GetProducts(
    id: json["id"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
