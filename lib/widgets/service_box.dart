import 'package:flutter/material.dart';

class ServiceBox extends StatelessWidget {
  final String title;
  final double height;
  final String? imagePath;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isMain;

  const ServiceBox({
    super.key,
    required this.title,
    required this.height,
    required this.onTap,
    this.imagePath,
    this.icon,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isMain ? Colors.blue.shade100 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isMain
            ? Stack(
                children: [
                  // Title positioned at top-left
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  // Image/Icon positioned at bottom-right
                  Positioned(bottom: -8, right: -1, child: _buildContent()),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _buildContent(),
                ],
              ),
      ),
    );
  }

  Widget _buildContent() {
    // If imagePath is provided and not empty, show image
    if (imagePath != null && imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath!,
          height: isMain ? height * 1 : height * 0.4,
          width: isMain ? height * 1 : height * 0.4,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // If image fails to load, fallback to icon
            return _buildIcon();
          },
        ),
      );
    }
    // Otherwise, show icon
    else {
      return _buildIcon();
    }
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade200.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon ?? Icons.apps,
        size: isMain ? height * 0.25 : height * 0.2,
        color: Colors.blue.shade700,
      ),
    );
  }
}
