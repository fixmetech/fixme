import 'package:flutter/material.dart';

class HomeServicesHeader extends StatelessWidget {
  const HomeServicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with curve
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 101, 175, 249),
                  Color.fromARGB(255, 44, 116, 198),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Content (text + image)
        Positioned(
          top: 50,
          left: 24,
          right: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home Image
              Container(
                height: 135,
                width: 135,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/house.png"),
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Home Service Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Home Services",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "All in One Place",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for curved shape
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
