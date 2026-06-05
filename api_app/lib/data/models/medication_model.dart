class MedicationModel {
  final String? id;
  final String name;
  final String laboratory;
  final double price;
  final int stock;
  final String type;
  final String? image;

  MedicationModel({
    this.id,
    required this.name,
    required this.laboratory,
    required this.price,
    required this.stock,
    required this.type,
    this.image,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel(
        id: json['id']?.toString(),
        name: json['name'] ?? '',
        laboratory: json['laboratory'] ?? '',
        // price viene como float de MockAPI
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        // stock viene como float de commerce.price → cambia a int
        stock: double.tryParse(json['stock'].toString())?.toInt() ?? 0,
        type: json['type'] ?? 'Tableta',
        image: json['image']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'laboratory': laboratory,
    'price': price,
    'stock': stock,
    'type': type,
    if (image != null) 'image': image,
  };
}
