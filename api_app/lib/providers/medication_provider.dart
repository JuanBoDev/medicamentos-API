import 'package:flutter/material.dart';
import '../data/models/medication_model.dart';
import '../data/services/medication_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _service = MedicationService();

  List<MedicationModel> _medications = [];
  bool _loading = false;
  bool _saving = false;
  String? _error;

  List<MedicationModel> get medications => _medications;
  bool get loading => _loading;
  bool get saving => _saving;
  String? get error => _error;

  Future<void> fetchMedications() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _medications = await _service.getMedications();
    } catch (e) {
      _error = 'No se pudieron cargar los medicamentos';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addMedication(MedicationModel medication) async {
    _saving = true;
    notifyListeners();
    await _service.createMedication(medication);
    await fetchMedications();
    _saving = false;
    notifyListeners();
  }

  Future<void> editMedication(MedicationModel medication) async {
    _saving = true;
    notifyListeners();
    await _service.updateMedication(medication);
    await fetchMedications();
    _saving = false;
    notifyListeners();
  }

  Future<void> removeMedication(String id) async {
    _saving = true;
    notifyListeners();
    await _service.deleteMedication(id);
    await fetchMedications();
    _saving = false;
    notifyListeners();
  }
}
