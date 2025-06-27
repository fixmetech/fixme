import 'package:flutter/material.dart';

class CommonProfile extends StatelessWidget {
  final Widget body; // Each page's custom content
  final String title; // AppBar title
  final int selectedIndex;

  static const Color primaryColor = Color(0xFF1565C0); // Blue[800]

  const CommonProfile({
    super.key,
    required this.body,
    required this.title,
    required this.selectedIndex
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: body,
    );
  }
}
