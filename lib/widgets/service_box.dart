import 'package:flutter/material.dart';

class ServiceBox extends StatelessWidget {
  final String title;
  final double height;
  final String imagePath;
  final VoidCallback onTap;
  final bool isMain;

  const ServiceBox({
    super.key,
    required this.title,
    required this.height,
    required this.imagePath,
    required this.onTap,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: isMain ? height : height * 0.5,
                width: isMain ? height : height * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
