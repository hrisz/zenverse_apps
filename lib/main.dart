import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/view/navbar_bottom.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenverse Apps',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const DynamicBottomNavbar(),
    );
  }
}
