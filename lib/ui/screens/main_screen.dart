// lib/ui/screens/main_screen.dart
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Replace with your actual screens
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
          Container(color: Colors.yellow),
          Container(color: Colors.purple),
        ],
      ),
    );
  }
}
