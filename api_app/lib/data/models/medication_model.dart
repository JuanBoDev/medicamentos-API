class MedicationModel {
  final String? id;
  final String name;
  final String doseValue;
  final String doseUnit;
  final String doseForm;
  final String laboratory;
  final double price;
  final int stock;
  final String? image;

  MedicationModel({
    this.id,
    required this.name,
    required this.doseValue,
    required this.doseUnit,
    required this.doseForm,
    required this.laboratory,
    required this.price,
    required this.stock,
    this.image,
  });

  String get dose {
    final parsed = double.tryParse(doseValue);
    final displayValue = parsed != null && parsed == parsed.truncateToDouble()
        ? parsed.toInt().toString()
        : doseValue;
    return doseUnit.isNotEmpty ? '$displayValue $doseUnit' : displayValue;
  }

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel(
        id: json['id']?.toString(),
        name: json['name'] ?? '',
        doseValue: json['dose_value']?.toString() ?? '',
        doseUnit: json['dose_unit']?.toString() ?? '',
        doseForm: json['dose_form']?.toString() ?? '',
        laboratory: json['laboratory'] ?? '',
        // price puede venir como string o número
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        stock: (() {
          final stockValue = json['stock'];
          if (stockValue is num) return stockValue.toInt();
          return double.tryParse(stockValue?.toString() ?? '')?.toInt() ?? 0;
        })(),
        image: json['image']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'dose_value': doseValue,
    'dose_unit': doseUnit,
    'dose_form': doseForm,
    'laboratory': laboratory,
    'price': price,
    'stock': stock.toDouble(),
    if (image != null) 'image': image,
  };
}
