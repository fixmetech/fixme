import 'package:flutter/material.dart';

class HomeHeaders extends StatelessWidget {
  const HomeHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with curve
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            width: double.infinity,
            height: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB4D9FF), Color(0xFF9CCAFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        // Content (text + image)
        Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hello, Good Morning!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Saduni",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Profile Image
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  'https://wallpapers.com/images/hd/default-user-profile-icon-c8ljd88k8vow846e.png',
                ),
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
