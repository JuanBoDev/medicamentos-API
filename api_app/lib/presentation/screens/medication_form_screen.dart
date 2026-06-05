import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController _labCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;

  // Dropdown: solo Tableta o Jarabe
  String _selectedType = 'Tableta';
  final List<String> _types = ['Tableta', 'Jarabe'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.medication?.name ?? '');
    _labCtrl = TextEditingController(text: widget.medication?.laboratory ?? '');
    _priceCtrl = TextEditingController(
      text: widget.medication?.price.toStringAsFixed(2) ?? '',
    );
    _stockCtrl = TextEditingController(
      text: widget.medication?.stock.toString() ?? '',
    );
    // Si viene un medicamento a editar, usamos su tipo
    _selectedType = widget.medication?.type ?? 'Tableta';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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
      laboratory: _labCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      type: _selectedType,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nombre — máx 35 caracteres
              TextFormField(
                controller: _nameCtrl,
                maxLength: 35,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'[^a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]'),
                  ),
                ],
                decoration: _inputDecoration('Nombre', Icons.medication),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el nombre';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Laboratorio — máx 35 caracteres
              TextFormField(
                controller: _labCtrl,
                maxLength: 35,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(
                      r'[^a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]',
                    ), // Deniega todo lo que NO sea letras, acentos, ñ o espacio
                  ),
                ],
                decoration: _inputDecoration('Laboratorio', Icons.business),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el laboratorio';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Precio — solo decimales positivos
              TextFormField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // Solo permite números y punto decimal
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{1,3}\.?\d{0,2}$'),
                  ),
                ],
                decoration: _inputDecoration('Precio', Icons.attach_money),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Ingresa el precio';
                  }
                  if (double.tryParse(v) == null) {
                    return 'Precio inválido';
                  }
                  if (double.parse(v) <= 0) {
                    return 'El precio debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Stock — solo enteros positivos
              TextFormField(
                controller: _stockCtrl,
                maxLength: 4,
                keyboardType: TextInputType.number,
                // Solo permite dígitos enteros
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration('Stock', Icons.inventory),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Ingresa el stock';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Stock inválido';
                  }
                  if (int.parse(v) < 0) {
                    return 'El stock no puede ser negativo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tipo — dropdown Tableta o Jarabe
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: _inputDecoration('Tipo', Icons.category),
                items: _types
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 24),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
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
    );
  }

  // Método reutilizable para decoración de campos
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
