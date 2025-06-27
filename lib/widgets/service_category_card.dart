import 'package:fixme/screens/services/vehicle/asap_vehicle_service.dart';
import 'package:fixme/widgets/service_box.dart';
import 'package:flutter/material.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Row 1: Car & Home
          Row(
            children: [
              Expanded(
                child: ServiceBox(
                  title: 'car',
                  imagePath: "assets/images/car1.png",
                  height: 120,
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapVehicleService(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ServiceBox(
                  title: 'home',
                  imagePath: "assets/images/house.png",
                  height: 120,
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapVehicleService(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Towing, Electrical, Plumbing
          Row(
            children: [
              Expanded(
                child: ServiceBox(
                  title: 'towing',
                  height: 100,
                  imagePath: "assets/images/towing.png",
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapVehicleService(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ServiceBox(
                  title: 'electrical',
                  height: 100,
                  imagePath: "assets/images/electric.png",
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapVehicleService(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ServiceBox(
                  title: 'plumbing',
                  imagePath: "assets/images/water2.png",
                  height: 100,
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapVehicleService(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 3: More button full width
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('More services coming soon...')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/more.png", height: 60, width: 120),
                  const Text(
                    "More",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black54,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
