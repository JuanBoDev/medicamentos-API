import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medication_model.dart';
import '../../core/constants.dart';

class MedicationService {
  final String _url = '${AppConstants.baseUrl}/medications';

  Future<List<MedicationModel>> getMedications() async {
    final res = await http.get(Uri.parse(_url));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => MedicationModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener medicamentos');
  }

  Future<void> createMedication(MedicationModel medication) async {
    await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medication.toJson()),
    );
  }

  Future<void> updateMedication(MedicationModel medication) async {
    await http.put(
      Uri.parse('$_url/${medication.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(medication.toJson()),
    );
  }

  Future<void> deleteMedication(String id) async {
    await http.delete(Uri.parse('$_url/$id'));
  }
}
