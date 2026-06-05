import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medication_model.dart';
import '../../providers/medication_provider.dart';
import '../screens/medication_form_screen.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;
  const MedicationCard({super.key, required this.medication});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar medicamento'),
        content: Text(
          '¿Eliminar "${medication.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<MedicationProvider>().removeMedication(medication.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stockBajo = medication.stock <= 5;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono izquierdo
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.medication, color: Colors.green),
            ),
            const SizedBox(width: 12),

            // Información central
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medication.laboratory,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Badge tipo: Tableta o Jarabe
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: medication.type == 'Tableta'
                          ? Colors.blue[50]
                          : Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      medication.type,
                      style: TextStyle(
                        fontSize: 11,
                        color: medication.type == 'Tableta'
                            ? Colors.blue[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Badge stock
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: stockBajo ? Colors.orange[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Stock: ${medication.stock}',
                      style: TextStyle(
                        fontSize: 11,
                        color: stockBajo
                            ? Colors.orange[700]
                            : Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Precio y botones derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${medication.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.green,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MedicationFormScreen(medication: medication),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
