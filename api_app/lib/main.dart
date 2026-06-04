import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/medication_provider.dart';
import 'presentation/screens/medication_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MedicationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmaApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MedicationListScreen(),
    );
  }
}
