import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medication_model.dart';
import '../../providers/medication_provider.dart';
import '../widgets/medication_card.dart';
import 'medication_form_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<MedicationProvider>().fetchMedications(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // El buscador filtra por name, laboratory y type
  List<MedicationModel> _filterMedications(List<MedicationModel> medications) {
    final term = _searchTerm.trim().toLowerCase();
    if (term.isEmpty) return medications;
    return medications.where((m) {
      return m.name.toLowerCase().contains(term) ||
          m.laboratory.toLowerCase().contains(term) ||
          m.type.toLowerCase().contains(term);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicationProvider>();
    final filteredMedications = _filterMedications(provider.medications);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_pharmacy, color: Colors.white),
            SizedBox(width: 8),
            Text('FarmaApp', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        // CircularProgressIndicator en AppBar al guardar/eliminar
        actions: [
          if (provider.saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      // CircularProgressIndicator al cargar la lista
      body: provider.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          : provider.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MedicationProvider>().fetchMedications(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : provider.medications.isEmpty
          ? const Center(
              child: Text(
                'No hay medicamentos registrados',
                style: TextStyle(color: Color(0xFF81C784)),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (value) => setState(() {
                      _searchTerm = value;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Buscar medicamentos',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF2E7D32),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: filteredMedications.isEmpty
                      ? Center(
                          child: Text(
                            _searchTerm.isEmpty
                                ? 'No hay medicamentos registrados'
                                : 'No se encontraron resultados para "$_searchTerm"',
                            style: const TextStyle(
                              color: Color(0xFF81C784),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredMedications.length,
                          itemBuilder: (_, i) => MedicationCard(
                            medication: filteredMedications[i],
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MedicationFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
    );
  }
}
