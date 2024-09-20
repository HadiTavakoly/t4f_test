class Product {
  final String type;
  final String title;
  final String image;
  final String price;
  final String city;
  final String presenter;
  final String runtime;
  final String rate;
  final String url;
  final String id;

  Product({
    required this.type,
    required this.title,
    required this.image,
    required this.price,
    required this.city,
    required this.presenter,
    required this.runtime,
    required this.rate,
    required this.url,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        type: json["type"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
        city: json["city"],
        presenter: json["presenter"],
        runtime: json["runtime"],
        rate: json["rate"],
        url: json["url"],
        id: json["id"],
      );
}
