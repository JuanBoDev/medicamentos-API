import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medication_model.dart';
import '../../providers/medication_provider.dart';

class MedicationFormScreen extends StatefulWidget {
  final MedicationModel? medication;
  const MedicationFormScreen({super.key, this.medication});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _doseValueCtrl;
  late TextEditingController _doseUnitCtrl;
  late TextEditingController _doseFormCtrl;
  late TextEditingController _labCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.medication?.name ?? '');
    _doseValueCtrl = TextEditingController(
      text: widget.medication?.doseValue ?? '',
    );
    _doseUnitCtrl = TextEditingController(
      text: widget.medication?.doseUnit ?? '',
    );
    _doseFormCtrl = TextEditingController(
      text: widget.medication?.doseForm ?? '',
    );
    _labCtrl = TextEditingController(text: widget.medication?.laboratory ?? '');
    _priceCtrl = TextEditingController(
      text: widget.medication?.price.toStringAsFixed(2) ?? '',
    );
    _stockCtrl = TextEditingController(
      text: widget.medication?.stock.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _doseValueCtrl.dispose();
    _doseUnitCtrl.dispose();
    _doseFormCtrl.dispose();
    _labCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final medication = MedicationModel(
      id: widget.medication?.id,
      name: _nameCtrl.text.trim(),
      doseValue: _doseValueCtrl.text.trim(),
      doseUnit: _doseUnitCtrl.text.trim(),
      doseForm: _doseFormCtrl.text.trim(),
      laboratory: _labCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
    );

    final provider = context.read<MedicationProvider>();

    if (widget.medication == null) {
      await provider.addMedication(medication);
    } else {
      await provider.editMedication(medication);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medication != null;
    final provider = context.watch<MedicationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Medicamento' : 'Nuevo Medicamento',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(
                    controller: _nameCtrl,
                    label: 'Nombre',
                    icon: Icons.medication,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingresa el nombre' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _doseValueCtrl,
                    label: 'Dosis (valor)',
                    icon: Icons.science,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Ingresa el valor de la dosis'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _doseUnitCtrl,
                    label: 'Unidad de dosis (mg, ml)',
                    icon: Icons.straighten,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Ingresa la unidad de dosis'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _doseFormCtrl,
                    label: 'Forma (tableta, jarabe)',
                    icon: Icons.category,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Ingresa la forma del medicamento'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _labCtrl,
                    label: 'Laboratorio',
                    icon: Icons.business,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Ingresa el laboratorio'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _priceCtrl,
                    label: 'Precio',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa el precio';
                      if (double.tryParse(v) == null) return 'Precio inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _stockCtrl,
                    label: 'Stock',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa el stock';
                      if (double.tryParse(v) == null) return 'Stock inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                      // Muestra CircularProgressIndicator al guardar
                      onPressed: provider.saving ? null : _submit,
                      icon: provider.saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? 'Actualizar' : 'Crear'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}
