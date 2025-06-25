import 'package:flutter/material.dart';

class ServiceBox extends StatelessWidget {
  final String title;
  final double height;

  const ServiceBox({super.key, required this.title, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Change to black if needed
          ),
        ),
      ),
    );
  }
}
