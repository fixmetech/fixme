import 'package:fixme/screens/services/home/asap_home_services.dart';
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
                  icon: Icons.directions_car,
                  imagePath: 'assets/images/car.png',
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
                  icon: Icons.home,
                  imagePath: 'assets/images/home.png',
                  height: 120,
                  isMain: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AsapHomeServices(),
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
                  title: 'Towing',
                  height: 100,
                  icon: Icons.car_repair,
                  isMain: false,
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
                  title: 'service center',
                  height: 100,
                  icon: Icons.electric_car,
                  isMain: false,
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
                  title: 'Marketplace',
                  icon: Icons.shopping_cart,
                  height: 100,
                  isMain: false,
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
        ],
      ),
    );
  }
}
